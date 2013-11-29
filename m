Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3K2QEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:04:08 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:53965 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3K2QED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:04:03 -0500
Date: Fri, 29 Nov 2013 16:03:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 00/10] ASoC: dma: ARM: ux500: Obtain DMA data from Device
 Tree
Message-ID: <20131129160358.GD26982@lee--X1>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, Lee Jones wrote:

> At this moment in time the Ux500 ASoC driver obtains its DMA information
> via AUXDATA platform data passing. To make the driver more independent
> we have to start extracting it from the Device Tree.
>  
> If this patch-set could go through ASoC as a whole, it would drive down
> the chance of a dependency mess. Vinod has already provided Acks for his
> parts, so it's just between you two Linus and Mark.
> 
>  Documentation/devicetree/bindings/dma/ste-dma40.txt |   3 ++
>  arch/arm/boot/dts/ste-dbx5x0.dtsi                   |  15 ++++++++++
>  arch/arm/mach-ux500/board-mop500-audio.c            |   8 +++---
>  drivers/dma/ste_dma40.c                             |   4 +++
>  include/linux/platform_data/asoc-ux500-msp.h        |   9 +-----
>  sound/soc/ux500/mop500.c                            |   2 ++
>  sound/soc/ux500/ux500_msp_dai.c                     | 150 +++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
>  sound/soc/ux500/ux500_msp_i2s.c                     |  56 +++++++++++++++++++++++++++----------
>  sound/soc/ux500/ux500_msp_i2s.h                     |   2 +-
>  sound/soc/ux500/ux500_pcm.c                         |  32 +++++++++++++++------
>  10 files changed, 160 insertions(+), 121 deletions(-)
> 
> Cc: Mark Brown <broonie@kernel.org>

Hi Mark,

Are you/did you already tak(e)ing this set?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
