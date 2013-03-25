Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3CYN7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:59:08 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57926 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3CYN7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:59:07 -0400
Message-ID: <51505825.2060805@gmail.com>
Date: Mon, 25 Mar 2013 08:59:01 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        kevin@allwinnertech.com, sunny@allwinnertech.com
Subject: Re: [PATCH 08/10] ARM: sunxi: dt: Update interrupt controller compatible
 string
References: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com> <1364218233-29636-9-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364218233-29636-9-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 08:30 AM, Maxime Ripard wrote:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi |    2 +-
>  arch/arm/boot/dts/sun5i-a13.dtsi |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
> index be71782..805d704 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -121,7 +121,7 @@
>  		ranges;
>  
>  		intc: interrupt-controller@01c20400 {
> -			compatible = "allwinner,sunxi-ic";
> +			compatible = "allwinner,sun4i-ic";

Generally speaking, this is a bad thing to do. This breaks compatibility
between dtb and kernel versions. If that breakage is not yet a concern
for sunxi, then it is okay.

Also, I don't see any documentation updates for any of these changes.

Rob

>  			reg = <0x01c20400 0x400>;
>  			interrupt-controller;
>  			#interrupt-cells = <1>;
> diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
> index 7a81aaf..760222c 100644
> --- a/arch/arm/boot/dts/sun5i-a13.dtsi
> +++ b/arch/arm/boot/dts/sun5i-a13.dtsi
> @@ -122,7 +122,7 @@
>  		ranges;
>  
>  		intc: interrupt-controller@01c20400 {
> -			compatible = "allwinner,sunxi-ic";
> +			compatible = "allwinner,sun4i-ic";
>  			reg = <0x01c20400 0x400>;
>  			interrupt-controller;
>  			#interrupt-cells = <1>;
> 

