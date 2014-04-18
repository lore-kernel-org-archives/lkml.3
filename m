Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaDRPbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:31:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:23905 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaDRPbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:31:32 -0400
Message-ID: <53514551.8030601@atmel.com>
Date: Fri, 18 Apr 2014 17:31:29 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: fix spi cs on sama5d3 Xplained board
References: <1396336363-13709-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1396336363-13709-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2014 09:12, Bo Shen :
> The PD16 is the CS3 for SPI0 while not SPI1.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Okay, queued in at91-3.15-fixes. Thanks



> ---
> This patch is based on v3.14-rc8
> 
>  arch/arm/boot/dts/at91-sama5d3_xplained.dts | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> index ce13755..4537259 100644
> --- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> +++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> @@ -34,7 +34,7 @@
>  			};
>  
>  			spi0: spi@f0004000 {
> -				cs-gpios = <&pioD 13 0>;
> +				cs-gpios = <&pioD 13 0>, <0>, <0>, <&pioD 16 0>;
>  				status = "okay";
>  			};
>  
> @@ -79,7 +79,7 @@
>  			};
>  
>  			spi1: spi@f8008000 {
> -				cs-gpios = <&pioC 25 0>, <0>, <0>, <&pioD 16 0>;
> +				cs-gpios = <&pioC 25 0>;
>  				status = "okay";
>  			};
>  
> 


-- 
Nicolas Ferre
