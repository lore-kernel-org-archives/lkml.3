Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaIEP0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:26:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:6834 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaIEP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:26:37 -0400
Message-ID: <5409D62B.2070902@atmel.com>
Date: Fri, 5 Sep 2014 17:26:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: rm9200: fix usb clock definition
References: <1409928312-24235-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1409928312-24235-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 16:45, Alexandre Belloni :
> The atmel,clk-divisors property is taking 4 divisors, if less are
> provided, the clock registration will fail.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Stacked on at91-3.17-fixes.

> ---
>  arch/arm/boot/dts/at91rm9200.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
> index 65ccf564b9a5..6c97d4af61ee 100644
> --- a/arch/arm/boot/dts/at91rm9200.dtsi
> +++ b/arch/arm/boot/dts/at91rm9200.dtsi
> @@ -149,7 +149,7 @@
>  				usb: usbck {
>  					compatible = "atmel,at91rm9200-clk-usb";
>  					#clock-cells = <0>;
> -					atmel,clk-divisors = <1 2>;
> +					atmel,clk-divisors = <1 2 0 0>;
>  					clocks = <&pllb>;
>  				};
>  
> 


-- 
Nicolas Ferre
