Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3BFDRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:17:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1654 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFDRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:17:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 05 Feb 2013 19:17:04 -0800
Message-ID: <5111CB2B.80807@nvidia.com>
Date: Wed, 6 Feb 2013 08:46:59 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: Fix build for Allwinner A1X SoCs
References: <1360076747-2162-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1360076747-2162-1-git-send-email-thierry.reding@avionic-design.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 08:35 PM, Thierry Reding wrote:
> Commit 85a1819 (clk: sunxi: Use common of_clk_init() function) removed
> the source file but didn't update the Makefile, therefore causing the
> build to break on Allwinner A1X SoCs.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Thanks Thierry!!

> ---
>   drivers/clk/Makefile | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index ce77077..be9392e 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -25,7 +25,6 @@ endif
>   obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
>   obj-$(CONFIG_ARCH_U8500)	+= ux500/
>   obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
> -obj-$(CONFIG_ARCH_SUNXI)	+= clk-sunxi.o
>   obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
>   obj-$(CONFIG_X86)		+= x86/
>   obj-$(CONFIG_ARCH_TEGRA)	+= tegra/

