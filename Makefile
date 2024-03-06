NAME = fractol
LIBMLX_PATH = ./MLX42
LIBMLX = $(LIBMLX_PATH)/build/libmlx42.a
LIBFTA_PATH = ./libfta
LIBFTA = $(LIBFTA_PATH)/libft.a
CFLAGS = -Wall -Wextra -Werror -Wunreachable-code -Ofast
HEADERS = -I ./incudes -I ./include -I $(LIBMLX_PATH)/include/ -I "/Users/stigkas/.brew/opt/glfw/include"
LIBS = $(LIBFTA) $(LIBMLX) -L/Users/stigkas/.brew/lib/ -ldl -lglfw -pthread -lm
SRCS = \
	complex_utils.c \
	fractol.c \
	hooks.c \
	init.c \
	render.c \
	utils.c \
	exit_errors.c
SRCS_BONUS = \
	complex_utils_bonus.c \
	fractol_bonus.c \
	hooks_bonus.c \
	init_bonus.c \
	render_bonus.c \
	utils_bonus.c \
	exit_errors_bonus.c

OBJS = $(SRCS:.c=.o)
BONUS_OBJ = $(SRCS_BONUS:.c=.o)
RM = rm -f

all: libmlx $(NAME)

libmlx:
	@cmake $(LIBMLX_PATH) -B $(LIBMLX_PATH)/build && make -C $(LIBMLX_PATH)/build -j4

$(NAME): $(LIBMLX) $(SRCS) $(OBJS)
	cd libfta && $(MAKE)
	cc $(CFLAGS) $(HEADERS) $(SRCS) $(LIBS) -o $(NAME)

$(OBJS): %.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $< $(HEADERS)

$(BONUS_OBJ): %.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $< $(HEADERS)

clean:
	@rm -rf $(OBJS)
	@rm -rf $(LIBMLX_PATH)/build
	cd $(LIBFTA_PATH) && make clean
	@rm -f $(BONUS_OBJ) .bonus

fclean: clean
	@rm -rf $(NAME)
	cd $(LIBFTA_PATH) && make fclean

re: fclean all

bonus: .bonus

.bonus: libmlx $(NAME) $(BONUS_OBJ)
	cd $(LIBFTA_PATH) && make bonus
	@touch .bonus

.PHONY: all clean fclean re libmlx bonus
