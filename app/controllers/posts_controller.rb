# frozen_string_literal: true

# return json
class PostsController < ApplicationController
	before_action :set_post, only: [:show, :update]
	before_action :authenticate_user!, only: [:create, :destroy, :show, :update]
  before_action :correct_user, only: %i[destroy]

	def create
		post = current_user.posts.build(post_params)
		if post.save
			render json: { status: 'SUCCESS', data: post }
		else
			render json: { status: 'ERROR', data: post.error }
		end
	end

	def destroy
		@post.destroy
		render json: { status:'SUCCESS', message: 'Deleted post', data: @post }
	end

	def update
		if @post.update(post_params)
			render json: { status: 'SUCCESS', message: 'Updated the post', data: @post }
		else
			render json: { status: 'ERROR', message: 'Not updated', data: @post.error}
		end
	end

	def show
		render json: { status: 'SUCCESS', message: 'Loaded the post', data: @post }
	end

	def index
		@posts = Post.order(created_at: :asc)
		render json: { status: 'SUCCESS', message: 'Loaded posts', data: @posts}
	end

	private
		def post_params
				params.require(:post).permit(:body)
		end

		def set_post
				@post = Post.find(params[:id])
		end

		def correct_user
			@post = current_user.posts.find(params[:id])
		end
end
