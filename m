Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3GWB3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:29:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38805 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3GWB3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:29:49 -0400
Date: Tue, 23 Jul 2013 10:29:47 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3 07/15] DMA: shdma: add sh73a0 DMAC data to the device
 ID table
Message-ID: <20130723012946.GF16481@verge.net.au>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
 <1374251374-30186-8-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1307201326110.3716@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1307201326110.3716@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 01:28:48PM +0200, Guennadi Liakhovetski wrote:
> This configuration data will be re-used, when DMAC DT support is added to
> sh73a0, DMAC platform data in setup-sh73a0.c will be removed.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
> 
> v3: also add an of_device_id entry for sh73a0.

Please don't post an update for just one patch in a series.
Please repost the entire series, even if only one patch is changed.

> 
>  drivers/dma/sh/Kconfig        |    4 +
>  drivers/dma/sh/Makefile       |    1 +
>  drivers/dma/sh/shdma-sh73a0.c |  181 +++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/sh/shdma.h        |    7 ++
>  drivers/dma/sh/shdmac.c       |    2 +
>  5 files changed, 195 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/sh/shdma-sh73a0.c
