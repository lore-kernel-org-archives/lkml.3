Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaIRPHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:07:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60067 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaIRPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:07:21 -0400
Message-ID: <541AF520.3050705@atmel.com>
Date: Thu, 18 Sep 2014 17:07:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: sama5d3: add the nfc clock
References: <1410857037-24445-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410857037-24445-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/2014 10:43, Alexandre Belloni :
> The atmel_nand driver is now able to handle the nfc clock, add it to sama5d3.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Stacked on at91-3.18-dt3 branch.

Thanks,

> ---
>  arch/arm/boot/dts/sama5d3.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 7702a0d120cb..cd36c76fd4e3 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -1005,6 +1005,11 @@
>  						reg = <2>;
>  					};
>  
> +					hsmc_clk: hsmc_clk {
> +						#clock-cells = <0>;
> +						reg = <5>;
> +					};
> +
>  					pioA_clk: pioA_clk {
>  						#clock-cells = <0>;
>  						reg = <6>;
> @@ -1405,6 +1410,7 @@
>  					0xffffc000 0x00000070	/* NFC HSMC regs */
>  					0x00200000 0x00100000	/* NFC SRAM banks */
>  					>;
> +				clocks = <&hsmc_clk>;
>  			};
>  		};
>  	};
> 


-- 
Nicolas Ferre
