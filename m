Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaAWKTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:19:37 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51058 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAWKTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:19:31 -0500
MIME-Version: 1.0
In-Reply-To: <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com> <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 23 Jan 2014 15:49:10 +0530
Message-ID: <CAHfPSqApkkRbnSXtLoEFMYoYTk5J+5YViNCzCd95qo8X53WZzQ@mail.gmail.com>
Subject: Re: [PATCH 6/8 v4] ARM: dts: exynos5250/5420: add dt node for sss module
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 15 January 2014 14:46, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds the device tree node for SSS module
> found on Exynos5420 and Exynos5250
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v3:
> 1. Modified the SSS clock ID as per dt-bindings for Exynos5250 in
>    samsung-clk.git tree.
>
>  arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>  arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index c341e55..1d249df 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -704,4 +704,12 @@
>                 io-channel-ranges;
>                 status = "disabled";
>         };
> +
> +       sss@10830000 {
> +               compatible = "samsung,exynos4210-secss";
> +               reg = <0x10830000 0x10000>;
> +               interrupts = <0 112 0>;
> +               clocks = <&clock 348>;
> +               clock-names = "secss";
> +       };
>  };
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 11dd202..56a3f3e 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -652,4 +652,14 @@
>                 clocks = <&clock 319>, <&clock 318>;
>                 clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>         };
> +
> +       sss@10830000 {
> +               compatible = "samsung,exynos4210-secss";
> +               reg = <0x10830000 0x10000>;
> +               interrupts = <0 112 0>;
> +               clocks = <&clock 471>;
> +               clock-names = "secss";
> +               samsung,power-domain = <&g2d_pd>;
> +       };
> +
>  };
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)
