Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3IBHDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:03:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:63632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab3IBHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:03:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="372110908"
Date: Mon, 2 Sep 2013 11:46:56 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 00/18] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Message-ID: <20130902061656.GF7376@intel.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 07:59:12PM +0200, Tomasz Figa wrote:
> This is first non-RFC version of my patches extending support of
> amba-pl08x DMA engine driver to PL080S DMA engine (PL080 modified by
> Samsung) found in Samsung S3C64xx SoCs.
> 
> Due to changes scattered across different areas of kernel, patches are
> based on merged 3 branches:
>  - for-next of Kgene's Samsung tree,
>  - clk-next of Mike's clock tree,
>  - next of Vinod's slave DMA tree.
> 
> To ease testing I have prepared a branch in my private tree for anyone
> willing to check the patches out:
> 	git://github.com/tom3q/linux.git v3.12-pl080
> 
> Dependencies (already applied in my branch):
>  - for patches 14 and 16 - CCF-based clock driver for s3c64xx.
>  
> Some of the patches not related to the amba-pl08x driver itself
> can be likely applied into appropriate trees separately, namely:
>  - 09/18 - ASoC: Samsung: Do not queue cyclic buffers multiple times,
>  - 14/18 - clk: samsung: s3c64xx: Add aliases for DMA clocks.
>  
> After patch 14/18, both old and new DMA drivers can be supported on
> S3C64xx, depending on Kconfig options. Patches 15-18 remove the old driver
> leaving support only for the generic pl08x driver. Feel free to drop those
> patches for now if we want more testing, but I don't suspect any problems.
> 
> On S3C64xx-based Mini6410 and SMDK6410 boards, with I2S audio
> playback and capture (including full duplex operation) and also SPI
> using spidev:
Applied 1-8 to slave-dma tree, thanks

~Vinod
