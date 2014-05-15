Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaEOQLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:11:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33952 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751629AbaEOQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:11:36 -0400
Date: Thu, 15 May 2014 18:11:32 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: at91/dt: add DMA controller node to at91sam9rl
Message-ID: <20140515161132.GT29318@piout.net>
References: <47a342121566bca0025a20a57282fb72c990ce09.1400166895.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a342121566bca0025a20a57282fb72c990ce09.1400166895.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/2014 at 17:15:23 +0200, Nicolas Ferre wrote :
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/at91sam9rl.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
> index 6e6e87dd0c92..412617084cfd 100644
> --- a/arch/arm/boot/dts/at91sam9rl.dtsi
> +++ b/arch/arm/boot/dts/at91sam9rl.dtsi
> @@ -348,6 +348,15 @@
>  				};
>  			};
>  
> +			dma0: dma-controller@ffffe600 {
> +				compatible = "atmel,at91sam9rl-dma";
> +				reg = <0xffffe600 0x200>;
> +				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
> +				#dma-cells = <2>;
> +				clocks = <&dma0_clk>;
> +				clock-names = "dma_clk";
> +			};
> +
>  			ramc0: ramc@ffffea00 {
>  				compatible = "atmel,at91sam9260-sdramc";
>  				reg = <0xffffea00 0x200>;
> -- 
> 1.8.2.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
