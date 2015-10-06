class ProdutosController < ApplicationController

    before_action :set_produto, only: [:edit, :update, :destroy]

	def index
        @produtos_por_nome = Produto.order(:nome).limit 5
        @produtos_por_preco = Produto.order(:preco).limit 2
    end

    def busca
          @nome_a_buscar = params[:nome]
          @produtos = Produto.where "nome like ?", "%#{@nome_a_buscar}%" 
    end
    
    def create
         valores = produto_params
         @produto = Produto.new valores
         if @produto.save
            flash[:notice] = "Produto salvo com sucesso"
            redirect_to root_url
         else
            inicializa_selects
            render :new
         end   
    end

    def edit
       inicializa_selects
       render :edit
       
    end

    def update
        valores = produto_params
        if @produto.update valores  
            flash[:notice] = "Produto atualizado com sucesso"  
            redirect_to root_url    
        else
              inicializa_selects
              render partial: 'form', locals: {texto_da_acao: 'Alterar o produto'} 
        end

    end

    def destroy
        set_produto
        @produto.destroy
        redirect_to root_url
    end

    def new
      @produto = Produto.new
      @departamentos = Departamento.all
    end

    private

    def inicializa_selects
        @departamentos = Departamento.all
    end

    def set_produto
        id = params[:id]
        @produto = Produto.find(id)
    end

    def produto_params
         params.require(:produto).permit :nome, :preco, :descricao, :quantidade, :departamento_id
    end


end
