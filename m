Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3E3Oxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:53:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41075 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab3E3Oxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:53:30 -0400
Date: Thu, 30 May 2013 15:53:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Various DT fixes related to ux500 ASoC driver
Message-ID: <20130530145323.GB1915@gmail.com>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Fabio Baltieri wrote:

> Hi Linus, Lee,
> 
> these are various fixes I found while testing the ux500 ASoC driver on HREF
> with device-tree.
> 
> First two patches are typos in DT files, while the others are
> specifically to support ux500 ASoC driver with DT enabled.
> 
> The last patch can go in the mfd tree, while the others may safely go
> through arm-soc, as there are no build dependencies or regression issues
> in general.
> 
> Thanks,
> Fabio
> 
> 
> Fabio Baltieri (5):
>   ARM: ux500: Fix trivial typo in v-anamic1 comment
>   ARM: ux500: Correct anamic2 typo in DT files
>   ARM: ux500: Add DT regulators for ab8500-codec
>   ARM: ux500: Provide auxdata to ux500 ASoC driver
>   mfd: ab8500-core: Add of_compatible property for ab8500-codec
> 
>  arch/arm/boot/dts/dbx5x0.dtsi     | 11 ++++++++---
>  arch/arm/boot/dts/href.dtsi       |  2 +-
>  arch/arm/boot/dts/hrefv60plus.dts |  2 +-
>  arch/arm/boot/dts/snowball.dts    |  2 +-
>  arch/arm/mach-ux500/cpu-db8500.c  |  2 ++
>  drivers/mfd/ab8500-core.c         |  1 +
>  drivers/regulator/ab8500.c        |  8 ++++----
>  7 files changed, 18 insertions(+), 10 deletions(-)

All look good to me.

For patches 1-4:

Acked-by: Lee Jones <lee.jones@linaro.org>

For patch 5:

Applied thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
