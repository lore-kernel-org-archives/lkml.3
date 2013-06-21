Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161101Ab3FUBpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:45:54 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:45095 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab3FUBpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:45:53 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: RE: [RFC PATCH 3/4] ARM: at91/dt: add sam9 watchdog default options
 to SoCs
Thread-Topic: [RFC PATCH 3/4] ARM: at91/dt: add sam9 watchdog default
 options to SoCs
Thread-Index: AQHOZpKg9YP3H24bP0WZVy+hujzwhZk/dCSA
Date: Fri, 21 Jun 2013 01:45:43 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641687DE064@penmbx01>
References: <1370947890-954-1-git-send-email-b.brezillon@overkiz.com>
 <1370947890-954-4-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1370947890-954-4-git-send-email-b.brezillon@overkiz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5L1k6ZI005468



> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org]
> On Behalf Of Boris BREZILLON
> Sent: 2013Äê6ÔÂ11ÈÕ 18:51
> To: Wim Van Sebroeck; Jean-Christophe Plagniol-Villard; Ferre, Nicolas
> Cc: Boris BREZILLON; Russell King; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; linux-watchdog@vger.kernel.org
> Subject: [RFC PATCH 3/4] ARM: at91/dt: add sam9 watchdog default options to
> SoCs
> 
> Set default watchdog options in every SoC compatible with the sam9 watchdog.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  arch/arm/boot/dts/at91sam9260.dtsi |    5 +++++
>  arch/arm/boot/dts/at91sam9263.dtsi |    5 +++++
>  arch/arm/boot/dts/at91sam9g45.dtsi |    5 +++++
>  arch/arm/boot/dts/at91sam9n12.dtsi |    5 +++++
>  arch/arm/boot/dts/at91sam9x5.dtsi  |    5 +++++
>  arch/arm/boot/dts/sama5d3.dtsi     |    5 +++++
>  6 files changed, 30 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9260.dtsi
> b/arch/arm/boot/dts/at91sam9260.dtsi
> index 899a7cf..6c44c35 100644
> --- a/arch/arm/boot/dts/at91sam9260.dtsi
> +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> @@ -643,6 +643,11 @@
>  			watchdog@fffffd40 {
>  				compatible = "atmel,at91sam9260-wdt";
>  				reg = <0xfffffd40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				atmel,watchdog-type = "hardware";
> +				atmel,reset-type = "all";
> +				atmel,dbg-halt;
> +				atmel,idle-halt;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi
> b/arch/arm/boot/dts/at91sam9263.dtsi
> index ff63811..6b31ee0 100644
> --- a/arch/arm/boot/dts/at91sam9263.dtsi
> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> @@ -519,6 +519,11 @@
>  			watchdog@fffffd40 {
>  				compatible = "atmel,at91sam9260-wdt";
>  				reg = <0xfffffd40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				atmel,watchdog-type = "hardware";
> +				atmel,reset-type = "all";
> +				atmel,dbg-halt;
> +				atmel,idle-halt;
>  				status = "disabled";
>  			};
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi
> b/arch/arm/boot/dts/at91sam9g45.dtsi
> index faec17d..ca1a643 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -634,6 +634,11 @@
>  			watchdog@fffffd40 {
>  				compatible = "atmel,at91sam9260-wdt";
>  				reg = <0xfffffd40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				atmel,watchdog-type = "hardware";
> +				atmel,reset-type = "all";
> +				atmel,dbg-halt;
> +				atmel,idle-halt;
>  				status = "disabled";
>  			};
> 
> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi
> b/arch/arm/boot/dts/at91sam9n12.dtsi
> index 3166e1d..7c8a5ea 100644
> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> @@ -505,6 +505,11 @@
>  			watchdog@fffffe40 {
>  				compatible = "atmel,at91sam9260-wdt";
>  				reg = <0xfffffe40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				atmel,watchdog-type = "hardware";
> +				atmel,reset-type = "all";
> +				atmel,dbg-halt;
> +				atmel,idle-halt;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi
> b/arch/arm/boot/dts/at91sam9x5.dtsi
> index e77106e..48eb1cc 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -742,6 +742,11 @@
>  			watchdog@fffffe40 {
>  				compatible = "atmel,at91sam9260-wdt";
>  				reg = <0xfffffe40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				atmel,watchdog-type = "hardware";
> +				atmel,reset-type = "all";
> +				atmel,dbg-halt;
> +				atmel,idle-halt;
>  				status = "disabled";
>  			};
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi
> b/arch/arm/boot/dts/sama5d3.dtsi
> index c00e158..7974723 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -885,6 +885,11 @@
>  			watchdog@fffffe40 {
>  				compatible = "atmel,at91sam9260-wdt";
>  				reg = <0xfffffe40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
Change it with,
				interrupts = <4 IRQ_TYPE_LEVEL_HIGH 7>;
Because in sama5d3, watchdog interrupt is not shared with SYSC, it uses a separate interrupt line, 4.
> +				atmel,watchdog-type = "hardware";
> +				atmel,reset-type = "all";
> +				atmel,dbg-halt;
> +				atmel,idle-halt;
>  				status = "disabled";
>  			};
> 
> --
> 1.7.9.5
> 
> 
Best Regards,
Wenyou Yang
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
