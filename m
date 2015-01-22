Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbbAVMyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:54:18 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:57665 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbAVMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <1421818097-9281-2-git-send-email-hongzhou.yang@mediatek.com>
References: <1421818097-9281-1-git-send-email-hongzhou.yang@mediatek.com>
	<1421818097-9281-2-git-send-email-hongzhou.yang@mediatek.com>
Date: Thu, 22 Jan 2015 13:54:12 +0100
Message-ID: <CABuKBeJGigY5ym9cJy=PYK8jbdsOLLtkmovHq6xho4gYseCAWg@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: mediatek: Add config options for mediatek SoCs.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Hongzhou Yang <hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com, alan.cheng@mediatek.com, toby.liu@mediatek.com,
        maoguang.meng@mediatek.com, huang eddie <eddie.huang@mediatek.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-21 6:28 GMT+01:00 Hongzhou Yang <hongzhou.yang@mediatek.com>:
> From: Yingjoe Chen <yingjoe.chen@mediatek.com>
>
> The upcoming MTK pinctrl driver have a big pin table for each SoC
> and we don't want to bloat the kernel binary if we don't need it.
> Add config options so we can build for one SoC only.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>

Applied to v3.20-next/soc

> ---
>  arch/arm/mach-mediatek/Kconfig | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
> index f73f588..f7e463c 100644
> --- a/arch/arm/mach-mediatek/Kconfig
> +++ b/arch/arm/mach-mediatek/Kconfig
> @@ -1,6 +1,26 @@
> -config ARCH_MEDIATEK
> +menuconfig ARCH_MEDIATEK
>         bool "Mediatek MT65xx & MT81xx SoC" if ARCH_MULTI_V7
>         select ARM_GIC
>         select MTK_TIMER
>         help
>           Support for Mediatek MT65xx & MT81xx SoCs
> +
> +if ARCH_MEDIATEK
> +
> +config MACH_MT6589
> +       bool "MediaTek MT6589 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +config MACH_MT6592
> +       bool "MediaTek MT6592 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +config MACH_MT8127
> +       bool "MediaTek MT8127 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +config MACH_MT8135
> +       bool "MediaTek MT8135 SoCs support"
> +       default ARCH_MEDIATEK
> +
> +endif
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
