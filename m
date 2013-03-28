Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3C1MVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:21:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab3C1MVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:21:13 -0400
Message-ID: <51543595.40004@ti.com>
Date: Thu, 28 Mar 2013 13:20:37 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        <hvaibhav@ti.com>
Subject: Re: [PATCH] ARM: dts: AM33XX: Corrects typo in interrupt field in
 SPI node
References: <1359697047-1816-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1359697047-1816-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

On 02/01/2013 06:37 AM, Philip Avinash wrote:
> DT field of "interrupts" was mentioned wrongly as "interrupt" in SPI
> node. This went unnoticed as spi-omap2 driver not making use of
> interrupt. Fixes the typo.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index fbcb90b..cece3ad 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -309,7 +309,7 @@
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			reg = <0x48030000 0x400>;
> -			interrupt = <65>;
> +			interrupts = <65>;
>  			ti,spi-num-cs = <2>;
>  			ti,hwmods = "spi0";
>  			status = "disabled";
> @@ -320,7 +320,7 @@
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			reg = <0x481a0000 0x400>;
> -			interrupt = <125>;
> +			interrupts = <125>;
>  			ti,spi-num-cs = <2>;
>  			ti,hwmods = "spi1";
>  			status = "disabled";
> 

Thanks for the fix. Applied with Peter Acked-by. It will be available in the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.10/dts

Regards,
Benoit
