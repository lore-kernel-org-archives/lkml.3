Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3HEKcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:32:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51630 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3HEKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:32:22 -0400
Date: Mon, 5 Aug 2013 12:32:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jingchang Lu <b35083@freescale.com>
Cc: vinod.koul@intel.com, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, djbw@fb.com
Subject: Re: [PATCH v2 2/3] ARM: dts: vf610: Add eDMA node
Message-ID: <20130805103214.GA30913@pengutronix.de>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375682824-11443-1-git-send-email-b35083@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:30:26 up 5 days, 19:34, 20 users,  load average: 0.02, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 02:07:03PM +0800, Jingchang Lu wrote:
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
> changes in v2:
>   using generic dma-channels property instead of fsl,dma-channels.
> 
> diff --git a/include/dt-bindings/dma/vf610-edma.h b/include/dt-bindings/dma/vf610-edma.h
> new file mode 100644
> index 0000000..3ae481c
> --- /dev/null
> +++ b/include/dt-bindings/dma/vf610-edma.h
> @@ -0,0 +1,103 @@
> +/*
> + * Copyright 2013 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + */
> +
> +#ifndef __DT_BINDINGS_DMA_VF610_H__
> +#define __DT_BINDINGS_DMA_VF610_H__
> +
> +/* DMAMUX0,3 reqeust slot number */
> +#define DMA_MUXID0_UART0_RX	2

Never add defines without a proper namespace. I suggest VF610_ here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
