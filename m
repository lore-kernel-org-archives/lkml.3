Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3HGL1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:27:48 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62638 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3HGL1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:27:46 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.54.65]
In-Reply-To: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Wed, 7 Aug 2013 13:27:45 +0200
Message-ID: <CABxcv==8Y7WasGBMByXPybzbP2ZA7jAnwpdiz4mnrtx_hHgr6Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: am33xx: Correct gpio #interrupt-cells property
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, b-cousson@ti.com, tony@atomide.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 1:06 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
>
> Following commit ff5c9059 and therefore other omap platforms using
> the gpio-omap driver correct the #interrupt-cells property on am33xx
> too. The omap gpio binding documentaion also states that
> the #interrupt-cells property should be 2.
>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 38b446b..033c5dd 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -102,7 +102,7 @@
>                         gpio-controller;
>                         #gpio-cells = <2>;
>                         interrupt-controller;
> -                       #interrupt-cells = <1>;
> +                       #interrupt-cells = <2>;
>                         reg = <0x44e07000 0x1000>;
>                         interrupts = <96>;
>                 };
> @@ -113,7 +113,7 @@
>                         gpio-controller;
>                         #gpio-cells = <2>;
>                         interrupt-controller;
> -                       #interrupt-cells = <1>;
> +                       #interrupt-cells = <2>;
>                         reg = <0x4804c000 0x1000>;
>                         interrupts = <98>;
>                 };
> @@ -124,7 +124,7 @@
>                         gpio-controller;
>                         #gpio-cells = <2>;
>                         interrupt-controller;
> -                       #interrupt-cells = <1>;
> +                       #interrupt-cells = <2>;
>                         reg = <0x481ac000 0x1000>;
>                         interrupts = <32>;
>                 };
> @@ -135,7 +135,7 @@
>                         gpio-controller;
>                         #gpio-cells = <2>;
>                         interrupt-controller;
> -                       #interrupt-cells = <1>;
> +                       #interrupt-cells = <2>;
>                         reg = <0x481ae000 0x1000>;
>                         interrupts = <62>;
>                 };
> --
> 1.7.10.4
>
>

Reviewed-by: Javier Martinez Canillas <javier@dowhile0.org>
