Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3BAGL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:11:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37207 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3BAGLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:11:54 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: RE: [PATCH] ARM: dts: AM33XX: Corrects typo in interrupt field in
 SPI node
Thread-Topic: [PATCH] ARM: dts: AM33XX: Corrects typo in interrupt field in
 SPI node
Thread-Index: AQHOAD8knbrBxv0KA0WXQhruWf/YdphkgqzQ
Date: Fri, 1 Feb 2013 06:10:25 +0000
Deferred-Delivery: Fri, 1 Feb 2013 06:10:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA6977C@DBDE01.ent.ti.com>
References: <1359697047-1816-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1359697047-1816-1-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 11:07:27, Philip, Avinash wrote:
> DT field of "interrupts" was mentioned wrongly as "interrupt" in SPI
> node. This went unnoticed as spi-omap2 driver not making use of
> interrupt. Fixes the typo.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Reported-by: Vaibhav Bedia <vaibhav.bedia@ti.com>

Typo mistake was reported by Vaibhav. I forgot to mention "Reported-by"
tag while posting. Add the same on his behalf.

Thanks
Avinash

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
> -- 
> 1.7.9.5
> 
> 

