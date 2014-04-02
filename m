Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbaDBL7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:59:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55939 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758593AbaDBL7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:59:22 -0400
Date: Wed, 2 Apr 2014 13:59:19 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91: fix spi cs on sama5d3 Xplained board
Message-ID: <20140402115919.GA14726@piout.net>
References: <1396336363-13709-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396336363-13709-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2014 at 15:12:43 +0800, Bo Shen wrote :
> The PD16 is the CS3 for SPI0 while not SPI1.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

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
> -- 
> 1.8.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
