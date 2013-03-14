Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3CNGWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:22:53 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:46172 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3CNGWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <1363195099-15919-1-git-send-email-dianders@chromium.org>
References: <1363195099-15919-1-git-send-email-dianders@chromium.org>
Date: Thu, 14 Mar 2013 11:52:51 +0530
Message-ID: <CAFp+6iEV+C_nGtMhCUQX-M4T3Ac2i8QeAhkGC1wxrCBTAJrNYw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: add usb 2.0 clock references to exynos5250
 device tree
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Padmavathi Venna <padma.v@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,


On Wed, Mar 13, 2013 at 10:48 PM, Doug Anderson <dianders@chromium.org> wrote:
> This is a fixup to two device tree nodes that have already landed but
> without clock nodes since the transition to common clock happened at
> the same time.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 24c52e6..59be603 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -402,12 +402,18 @@
>                 compatible = "samsung,exynos4210-ehci";
>                 reg = <0x12110000 0x100>;
>                 interrupts = <0 71 0>;
> +
> +               clocks = <&clock 285>;
> +               clock-names = "usbhost";
>         };
>
>         usb@12120000 {
>                 compatible = "samsung,exynos4210-ohci";
>                 reg = <0x12120000 0x100>;
>                 interrupts = <0 71 0>;
> +
> +               clocks = <&clock 285>;
> +               clock-names = "usbhost";

It will be nice if you can please update relevant information
alongwith this, in the bindings doc for "exynos-usb".

>         };
>
>         amba {
> --
> 1.8.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks & Regards
Vivek
