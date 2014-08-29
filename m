Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaH2Qqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:46:49 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:42990 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaH2Qqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:46:48 -0400
Message-ID: <5400AE71.9040104@atmel.com>
Date: Fri, 29 Aug 2014 18:46:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: at91/dt: sam9x5: fix ADC compatible string
References: <1406038067-14697-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1406038067-14697-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/2014 16:07, Alexandre Belloni :
> Use the correct compatible string for the ADC of the at91sam9x5 family of SoCs.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Yep!

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  arch/arm/boot/dts/at91sam9x5.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index 2c0d6ea3ab41..5d7cf394f537 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -964,7 +964,7 @@
>  			adc0: adc@f804c000 {
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> -				compatible = "atmel,at91sam9260-adc";
> +				compatible = "atmel,at91sam9x5-adc";
>  				reg = <0xf804c000 0x100>;
>  				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
>  				clocks = <&adc_clk>,
> 


-- 
Nicolas Ferre
