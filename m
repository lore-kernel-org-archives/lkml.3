Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3FLKtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:49:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33121 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3FLKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:48:59 -0400
Date: Wed, 12 Jun 2013 11:48:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 0/3] DMA fixes for ux500 ASoC driver
Message-ID: <20130612104852.GD4320@laptop>
References: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Fabio Baltieri wrote:

> Hi Mark,
> 
> The DMA driver used on ux500 has been recently reworked to make it
> device-tree capable, but the rework required to drop some "features",
> such as opportunistic channel allocation and hardcoded addresses, that
> the ASoC driver was relying upon.
> 
> This series fixes the audio driver to make it work with the current
> dma40 implementation, and works fine even when booting with device-tree.
> 
> Would you consider merging these for asoc/topic/ux500?
> 
> Thanks,
> Fabio
> 
> 
> Fabio Baltieri (3):
>   ASoC: ux500: Move DMA parameters into ux500_msp
>   ASoC: ux500: Set DMA address during device init
>   ASoC: ux500: Add DMA slave config prepare routine
> 
>  sound/soc/ux500/ux500_msp_dai.c | 11 ++++-------
>  sound/soc/ux500/ux500_msp_dai.h |  2 --
>  sound/soc/ux500/ux500_msp_i2s.c | 13 +++++++++----
>  sound/soc/ux500/ux500_msp_i2s.h | 15 ++++++++-------
>  sound/soc/ux500/ux500_pcm.c     | 30 ++++++++++++++++++++++++++++++
>  5 files changed, 51 insertions(+), 20 deletions(-)

I don't see anything visually wrong with them, so as long as they work
for you, then you can apply my:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
