Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaKSNRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:17:34 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:26073 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaKSNRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:17:32 -0500
Message-ID: <546C9867.70005@atmel.com>
Date: Wed, 19 Nov 2014 14:17:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: at91sam9rl: add rtc
References: <1412181692-21138-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1412181692-21138-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 18:41, Alexandre Belloni :
> Add rtc support to the at91sam9rl dtsi file.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And stacked on top of at91-3.19-dt2

Thanks, bye.

> ---
>  arch/arm/boot/dts/at91sam9rl.dtsi | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
> index ab56c8b81dfa..984468a56fa4 100644
> --- a/arch/arm/boot/dts/at91sam9rl.dtsi
> +++ b/arch/arm/boot/dts/at91sam9rl.dtsi
> @@ -1059,6 +1059,13 @@
>  					clocks = <&slow_rc_osc &slow_osc>;
>  				};
>  			};
> +
> +			rtc@fffffeb0 {
> +				compatible = "atmel,at91rm9200-rtc";
> +				reg = <0xfffffeb0 0x40>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				status = "disabled";
> +			};
>  		};
>  	};
>  
> 


-- 
Nicolas Ferre
