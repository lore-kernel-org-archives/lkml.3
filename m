Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbaIRQSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:18:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:21016 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbaIRQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:18:00 -0400
Message-ID: <541B05B1.6020302@atmel.com>
Date: Thu, 18 Sep 2014 18:17:53 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Erik van Luijk <evanluijk@interact.nl>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] ARM: at91/dt: at91sam9m10g45ek add rtc node
References: <1409655132-17735-1-git-send-email-evanluijk@interact.nl>
In-Reply-To: <1409655132-17735-1-git-send-email-evanluijk@interact.nl>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 12:52, Erik van Luijk :
> Signed-off-by: Erik van Luijk <evanluijk@interact.nl>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and added to the at91-3.18-dt3 branch.

I also sent your remarks to the Documentation department in Atmel:
thanks a lot for your help.

> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi     | 7 +++++++
>  arch/arm/boot/dts/at91sam9m10g45ek.dts | 3 +++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index 932a669..bf62c18 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -1070,6 +1070,13 @@
>  				status = "disabled";
>  			};
>  
> +			rtc@fffffdb0 {
> +				compatible = "atmel,at91rm9200-rtc";
> +				reg = <0xfffffdb0 0x30>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				status = "disabled";
> +			};
> +
>  			spi0: spi@fffa4000 {
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> index 96ccc7d..2dd2347 100644
> --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> @@ -70,6 +70,9 @@
>  
>  			watchdog@fffffd40 {
>  				status = "okay";

BTW, there was an issue here: "};" missing..

I corrected it.

> +
> +			rtc@fffffdb0 {
> +				status = "okay";
>  			};
>  
>  			mmc0: mmc@fff80000 {
> 


-- 
Nicolas Ferre
