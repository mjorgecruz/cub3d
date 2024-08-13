/******************************************************************************/
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   raycaster.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: masoares <masoares@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/29 11:30:25 by masoares          #+#    #+#             */
/*   Updated: 2024/08/13 17:39:55 by masoares         ###   ########.fr       */
/*                                                                            */
/******************************************************************************/

#include "../includes/cub3d.h"

void display(t_data *cub)
{
	double x;
	int side;
	double wallDist;
	double wall_pos;
	
	x = 1;
	side = 0;
	direction_calc(cub, 0);
	while(x <  WIN_W)
	{
		cub->player->cam->cameraX = (2 * x / (double) WIN_W) - 1;
		cub->player->cam->rayDirX = cub->player->pov->dirX + cub->player->cam->planeX * cub->player->cam->cameraX;
		cub->player->cam->rayDirY = cub->player->pov->dirY + cub->player->cam->planeY * cub->player->cam->cameraX;
		delta_calc_ray(cub);
		step_calc_ray(cub);
		side = side_calc_ray(cub);
		if(side == 1)
		{
			wallDist = fabs((cub->player->cam->r_sideDistX  - cub->player->cam->r_deltaX));
			wall_pos = cub->player->posX + (cub->player->cam->r_sideDistX  - cub->player->cam->r_deltaX) * cub->player->cam->rayDirX - (int)cub->player->posX;
		}
		else
		{
			wallDist = fabs((cub->player->cam->r_sideDistY - cub->player->cam->r_deltaY));
			wall_pos = cub->player->posY + (cub->player->cam->r_sideDistY  - cub->player->cam->r_deltaY) * cub->player->cam->rayDirY - (int)cub->player->posY;
		}
		line_display(cub, x, wallDist, side);
		x++;
	}
}

void delta_calc_ray(t_data *cub)
{
	cub->player->cam->r_mapX = (int)cub->player->posX;
	cub->player->cam->r_mapY = (int)cub->player->posY;
	if (cub->player->cam->rayDirX != 0)
		cub->player->cam->r_deltaX = sqrt(1 + (cub->player->cam->rayDirY * cub->player->cam->rayDirY) / (cub->player->cam->rayDirX * cub->player->cam->rayDirX));//fabs(1 / cub->player->cam->rayDirX); 
	else
		cub->player->cam->r_deltaX = 1e30;
	if (cub->player->cam->rayDirY != 0)
		cub->player->cam->r_deltaY = sqrt(1 + (cub->player->cam->rayDirX * cub->player->cam->rayDirX) / (cub->player->cam->rayDirY * cub->player->cam->rayDirY));//fabs(1 / cub->player->cam->rayDirY);
	else
		cub->player->cam->r_deltaY = 1e30;
}

void step_calc_ray(t_data *cub)
{
	if (cub->player->cam->rayDirX < 0)
	{
		cub->player->cam->r_stepX = -1;
		cub->player->cam->r_sideDistX = (cub->player->posX - cub->player->cam->r_mapX) * cub->player->cam->r_deltaX;
	}
	else
	{
		cub->player->cam->r_stepX = 1;
		cub->player->cam->r_sideDistX = (cub->player->cam->r_mapX + 1.0 - cub->player->posX) * cub->player->cam->r_deltaX;
	}
	if (cub->player->cam->rayDirY < 0)
	{
		cub->player->cam->r_stepY = -1;
		cub->player->cam->r_sideDistY = (cub->player->posY - cub->player->cam->r_mapY) * cub->player->cam->r_deltaY;
	}
	else
	{
		cub->player->cam->r_stepY = 1;
		cub->player->cam->r_sideDistY = (cub->player->cam->r_mapY + 1.0 - cub->player->posY) * cub->player->cam->r_deltaY;
	}
}

int side_calc_ray(t_data *cub)
{
	int hit;
	int side;

	side = 0;
	hit = 0;
	
	while (hit == 0)
	{
		if (fabs(cub->player->cam->r_sideDistX) < fabs(cub->player->cam->r_sideDistY))
		{
			cub->player->cam->r_sideDistX += cub->player->cam->r_deltaX;
			cub->player->cam->r_mapX += cub->player->cam->r_stepX;
			side = 1;
		}
		else
		{
			cub->player->cam->r_sideDistY += cub->player->cam->r_deltaY;
			cub->player->cam->r_mapY += cub->player->cam->r_stepY;
			side = 0;
		}
		if (cub->map[cub->player->cam->r_mapX][cub->player->cam->r_mapY] > 0)
			hit = 1;
	}
	return (side);
}

int		line_display(t_data *cub, int x, double wallDist, int side)
{
	//max_height = WIN_H when wallDist = 1
	int line_height;
	int yStart;
	int yEnd;
	int color;
	int pos;
	double wall_pos;
	double wallX;
	
	(void) side;
	(void) x;
	pos = 0;
	line_height = WIN_H / wallDist;
	yStart = (int)(-line_height / 2 + WIN_H / 2);
    if(yStart < 0)
		yStart = 0;
    yEnd = (int)(line_height / 2 + WIN_H / 2);
    if(yEnd >= WIN_H)
		yEnd = WIN_H - 1;
		
	if(side == 1)
		wall_pos = (cub->player->posX + (wallDist) * cub->player->cam->rayDirX);
	else
		wall_pos = cub->player->posY + (wallDist) * cub->player->cam->rayDirY;
	wallX = wall_pos - (double)((int)(wall_pos));
	pos = yStart;
	while (pos <= yEnd)
	{
		color = *(int *)(cub->north + (int)(wallX * (double)cub->texNorth.width) + ((pos-yStart)/yEnd - yStart)); //+ (int)(((double)pos - (double)yStart)/((double)yEnd - (double)yStart) * (double)cub->texNorth.height) * cub->texNorth.line_length / 8);
		pixel_put(cub, x, pos, color);
		pos++;
	}
	return(1);
}
