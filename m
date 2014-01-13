Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaAMBY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 20:24:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47376 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaAMBYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 20:24:54 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-d7-52d34061e631
From: Jingoo Han <jg1.han@samsung.com>
To: "'Stefan Kristiansson'" <stefan.kristiansson@saunalahti.fi>
Cc: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-reply-to: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH v5] video: add OpenCores VGA/LCD framebuffer driver
Date: Mon, 13 Jan 2014 10:24:49 +0900
Message-id: <000301cf0ffe$4054e8d0$c0feba70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8OQIPcTk78TDCCT5mq2tgauB7IzQBuvrgw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zY91Eh8tBBk93ylpcXniJ1eJE3wdW
	i8u75rBZrHv4gsni7KaVTBbr599ic2DzeHXhDotH35ZVjB4Hp3SzeRy/sZ3J4/MmuQDWKC6b
	lNSczLLUIn27BK6Muwt+sRWcEa7YensFawPjL/4uRk4OCQETiRkX5rJB2GISF+6tB7K5OIQE
	ljFKTD/ZxgJT1Pf0DwtEYhGjxLMZ95ggnF+MEkvaGsDa2QTUJL58OcwOYosI2EqsW7KIGaSI
	WeAso8TW29/BRgkJBEhMam4Fa+AUCJa4d/kfmC0s4C4xd+s8MJtFQFVi1d8vrCA2L9CgC5sn
	MULYghI/Jt8Dm8MsoCWxfudxJghbXmLzmrdAyziATlWXePRXF8QUETCSmPrRE6JCRGLfi3eM
	IOdICLxkl3g2YSkrxCoBiW+TD7FAtMpKbDrADPGwpMTBFTdYJjBKzEKyeBaSxbOQLJ6FZMUC
	RpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCFR27uD8fYB60OMyUDrJzJLiSbnA6M+ryTe
	0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYnRXXcUsz
	NB2JlufLWbIs3Nl9uVnf1/k7vFrOl09IqJYomPRFae/6xR4xq6xYVTNb5v7ODjY5KWhUH7D/
	0jsv3eU3jky75Jlzy7ApUPbnUcm50pr+vCe/8Wvu0ahv3HH7t9Kme4+uNIj8v1p2Xiyaf9eP
	RXe3sWbPVejr27pO5cTC6pi0N1dnKbEUZyQaajEXFScCAK64BNbwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jAd1Eh8tBBl0dkhaXF15itTjR94HV
	4vKuOWwW6x6+YLI4u2klk8X6+bfYHNg8Xl24w+LRt2UVo8fBKd1sHsdvbGfy+LxJLoA1qoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoBCWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt0Fv9gKzghXbL29grWB8Rd/FyMn
	h4SAiUTf0z8sELaYxIV769m6GLk4hAQWMUo8m3GPCcL5xSixpK2BDaSKTUBN4suXw+wgtoiA
	rcS6JYuYQYqYBc4ySmy9/R1slJBAgMSk5lawBk6BYIl7l/+B2cIC7hJzt84Ds1kEVCVW/f3C
	CmLzAg26sHkSI4QtKPFj8j2wOcwCWhLrdx5ngrDlJTaveQu0jAPoVHWJR391QUwRASOJqR89
	ISpEJPa9eMc4gVFoFpJBs5AMmoVk0CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BKeEZ9I7GFc1WBxiFOBgVOLhTRC4HCTEmlhWXJl7iFGCg1lJhHeFHVCINyWxsiq1KD++qDQn
	tfgQYzLQnxOZpUST84HpKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUw
	W5g4OKUaGDvqtFN+W3Jw+jt9m3pRpsFbYcaWhp+8RyraG9NfzF73oWH5rlkOcaVx/PciP3B4
	yU4oXq9w6p/D5oaHkrLrrkTxNKUqv6lS5l7aFKyyVPoJz9tUwdMHb/x6pLhst93uny1TWd7c
	WiA8cdq+yBdTu1cIOXw89M/tVfzb1VrsblXd5UdUprSe91ViKc5INNRiLipOBADjTMoyTQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 11, 2014 5:13 AM, Stefan Kristiansson wrote:
> 
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
> 
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
> Changes in v2:
> - Add Microblaze as an example user and fix a typo in Xilinx Zynq
> 
> Changes in v3:
> - Use devm_kzalloc instead of kzalloc
> - Remove superflous MODULE #ifdef
> 
> Changes in v4:
> - Remove 'default n' in Kconfig
> - Simplify ioremap/request_mem_region by using devm_ioremap_resource
> - Remove release_mem_region
> 
> Changes in v5:
> - Remove static structs to support multiple devices
> ---
>  drivers/video/Kconfig  |  16 ++
>  drivers/video/Makefile |   1 +
>  drivers/video/ocfb.c   | 440 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 457 insertions(+)
>  create mode 100644 drivers/video/ocfb.c

It looks good.
However, I added some minor comments. :-)
Sorry for late response.

[.....]

> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/mm.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/fb.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>

Would you re-order these headers alphabetically?
It enhances the readability.

[.....]

> +struct ocfb_dev {
> +	struct fb_info info;
> +	void __iomem *regs;
> +	/* flag indicating whether the regs are little endian accessed */
> +	int little_endian;
> +	/* Physical and virtual addresses of framebuffer */
> +	phys_addr_t fb_phys;
> +	void __iomem *fb_virt;
> +	u32 pseudo_palette[PALETTE_SIZE];
> +};

Here, 'fb_virt' is already defined as 'void __iomem *'.

[.....]

> +	fbdev->info.fix.smem_start = fbdev->fb_phys;
> +	fbdev->info.screen_base = (void __iomem *)fbdev->fb_virt;

Please remove unnecessary casting as below, because 'fb_virt' is already
defined as 'void __iomem *'.

+	fbdev->info.screen_base = fbdev->fb_virt;

> +	fbdev->info.pseudo_palette = fbdev->pseudo_palette;
> +
> +	/* Clear framebuffer */
> +	memset_io((void __iomem *)fbdev->fb_virt, 0, fbsize);

Same here.

+	memset_io(fbdev->fb_virt, 0, fbsize);

Best regards,
Jingoo Han

