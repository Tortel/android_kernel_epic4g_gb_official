/*
 * linux/arch/arm/mach-s5pv210/dev-onenand.c
 *
 *  Copyright (c) 2008-2010 Samsung Electronics
 *  Kyungmin Park <kyungmin.park@samsung.com>
 *
 * S5PC110 series device definition for OneNAND devices
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/onenand.h>

#include <mach/irqs.h>
#include <mach/map.h>

/* OneNAND Controller */
static struct resource s5p_onenand_resource[] = {
	[0] = {
		.start = S5P_PA_ONENAND,
		.end   = S5P_PA_ONENAND + S5P_SZ_ONENAND - 1,
		.flags = IORESOURCE_MEM,
	}
};

struct platform_device s5p_device_onenand = {
	.name		= "s5p-onenand",
	.id		= -1,
	.num_resources	= ARRAY_SIZE(s5p_onenand_resource),
	.resource	= s5p_onenand_resource,
};,
};

EXPORT_SYMBOL(s5p_device_onenand);

void s5pc110_onenand_set_platdata(struct onenand_platform_data *pdata)
{
	struct onenand_platform_data *pd;

	pd = kmemdup(pdata, sizeof(struct onenand_platform_data), GFP_KERNEL);
	if (!pd)
		printk(KERN_ERR "%s: no memory for platform data\n", __func__);
	s5p_device_onenand.dev.platform_data = pd;
}
