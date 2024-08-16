RED = \033[31m
GREEN = \033[32m
YELLOW = \033[33m
END_COLOR = \033[0m
BOLD_GREEN = \033[1;32m
BOLD_YELLOW = \033[1;33m
END = \033[0m

NAME = cub3d
NAME_BONUS = cub3d_bonus

CFLAGS = -Wall -Werror -Wextra -g

LIBMLX_DIR = lib/
LIBMLX = $(addprefix $(LIBMLX_DIR), libmlx.a)

LIBFT_DIR = libft/
LIBFT = $(addprefix $(LIBFT_DIR), libft.a)

VGFLAGS = valgrind --leak-check=full --suppressions=sup --track-origins=yes --show-leak-kinds=all --log-file=leaks.log -s

TESTFLAGS = -fsanitize=address

INCDIR:=srcs
ODIR:=obj
INCDIR_BONUS:=bonus
ODIR_BONUS:=obj_bonus

SRC := closing.c freeing.c handlers.c init_window.c \
		main.c main_utils.c minimaper.c raycaster.c \
		errors.c render.c minimaper_utils.c render_utils.c \
		minimaper_renders.c fileread.c fileread_utils.c\
		rgb.c parser_cub.c map_build.c tests.c

BONUS_SRC = closing_bonus.c freeing_bonus.c handlers_bonus.c init_window_bonus.c \
		main_bonus.c main_utils_bonus.c minimaper_bonus.c raycaster_bonus.c \
		errors_bonus.c render_bonus.c minimaper_utils_bonus.c render_utils_bonus.c \
		minimaper_renders_bonus.c fileread_bonus.c fileread_utils_bonus.c\
		rgb_bonus.c parser_cub_bonus.c map_build_bonus.c tests_bonus.c controls_bonus.c

OBJ := $(patsubst %.c, $(ODIR)/%.o,$(SRC))

OBJ_BONUS = $(patsubst %.c, $(ODIR_BONUS)/%.o,$(BONUS_SRC))

LIBFLAGS = $(LIBFT) -I$(LIBMLX_DIR) -L$(LIBMLX_DIR) -lmlx -lX11 -lXext -lm

CC = cc

RM = rm -f

TOTAL_FILES := $(words $(SRC))
COMPILED_FILES := $(shell if [ -d "$(ODIR)" ]; then find $(ODIR) -name "*.o" | wc -l; else echo 0; fi)

all: $(NAME)

bonus: $(NAME_BONUS)

$(NAME): $(OBJ) $(LIBFT) $(LIBMLX)
	@$(CC) $(CFLAGS) $(OBJ) $(LIBFLAGS) -o $(NAME)
	@printf "$(BOLD_GREEN)...cub3d in the making: $$(echo "$(shell find $(ODIR) -name "*.o" | wc -l) $(TOTAL_FILES)" | awk '{printf "%.2f", $$1/$$2 * 100}')%%$(RES)\r"
	@printf "\n"
	@echo "${BOLD_GREEN}cub3d is reborn...${END}"

$(NAME_BONUS):  $(OBJ_BONUS) $(LIBFT) $(LIBMLX)
	@$(CC) $(CFLAGS) $(OBJ_BONUS) $(LIBFLAGS) -o $(NAME_BONUS)
	@printf "$(BOLD_GREEN)... bonus cub3d in the making: $$(echo "$(shell find $(ODIR_BONUS) -name "*.o" | wc -l) $(TOTAL_FILES)" | awk '{printf "%.2f", $$1/$$2 * 100}')%%$(RES)\r"
	@printf "\n"
	@echo "${BOLD_GREEN}bonus cub3d is reborn...${END}"

$(ODIR):
	@mkdir -p $@
	
$(ODIR)/%.o: $(INCDIR)/%.c
	@mkdir -p $(dir $@) 
	@printf "$(BOLD_GREEN)...cub3d in the making: $$(echo "$(shell find $(ODIR) -name "*.o" | wc -l) $(TOTAL_FILES)" | awk '{printf "%.2f", $$1/$$2 * 100}')%%$(RES)\r"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(ODIR_BONUS):
	@mkdir -p $@
	
$(ODIR_BONUS)/%.o: $(INCDIR_BONUS)/%.c
	@mkdir -p $(dir $@) 
	@printf "$(BOLD_GREEN)...cub3d in the making: $$(echo "$(shell find $(ODIR_BONUS) -name "*.o" | wc -l) $(TOTAL_FILES)" | awk '{printf "%.2f", $$1/$$2 * 100}')%%$(RES)\r"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(LIBFT):
	@make -C $(LIBFT_DIR)
	@echo "${BOLD_GREEN}LIBFT BUILT${END}"

$(LIBMLX):
	@make -C $(LIBMLX_DIR)
	@echo "${GREEN}LIBMLX BUILT${END}"

fclean: clean
	@$(RM) $(NAME)
	@$(RM) $(NAME_BONUS)
#	@make clean -C $(LIBMLX_DIR)

clean:
	@$(RM) $(OBJ)
	@$(RM) $(OBJ_BONUS)
	@make fclean -C $(LIBFT_DIR)
	@echo "${RED}cub3d is no more...${END}"

re: fclean all
