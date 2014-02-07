Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaBGPrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:47:35 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:64971 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaBGPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:47:33 -0500
Message-ID: <52F50008.3050001@atmel.com>
Date: Fri, 7 Feb 2014 16:47:20 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
CC: <b.brezillon@overkiz.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] at91: dt: sam9263: fixed compatibility string for the
 I2C
References: <1389781486-29670-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1389781486-29670-1-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/2014 11:24, Jean-Jacques Hiblot :
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Added to at91-3.14-fixes

Thanks, bye,

> ---
>  arch/arm/boot/dts/at91sam9263.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
> index c8fa9b9..7d6dd09 100644
> --- a/arch/arm/boot/dts/at91sam9263.dtsi
> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> @@ -523,7 +523,7 @@
>  			};
>  
>  			i2c0: i2c@fff88000 {
> -				compatible = "atmel,at91sam9263-i2c";
> +				compatible = "atmel,at91sam9260-i2c";
>  				reg = <0xfff88000 0x100>;
>  				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
>  				#address-cells = <1>;
> 


-- 
Nicolas Ferre
