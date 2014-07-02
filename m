Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaGBIFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:05:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41209 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbaGBIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:05:00 -0400
Date: Wed, 2 Jul 2014 10:04:46 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/33] ARM: at91/dt: rm9200: define clocks
Message-ID: <20140702100446.14910191@bbrezillon>
In-Reply-To: <1404223962-30471-6-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1404223962-30471-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

On Tue,  1 Jul 2014 16:12:14 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Signed-off-by: Alexandre Belloni
> <alexandre.belloni@free-electrons.com> ---
>  arch/arm/boot/dts/at91rm9200.dtsi | 304
> ++++++++++++++++++++++++++++++++++++++ 1 file changed, 304
> insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91rm9200.dtsi
> b/arch/arm/boot/dts/at91rm9200.dtsi index c61b16fba79b..477cfe570f47
> 100644 --- a/arch/arm/boot/dts/at91rm9200.dtsi
> +++ b/arch/arm/boot/dts/at91rm9200.dtsi
> @@ -14,6 +14,7 @@
>  #include <dt-bindings/pinctrl/at91.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
>  #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/clock/at91.h>
>  
>  / {
>  	model = "Atmel AT91RM9200 family SoC";
> @@ -51,6 +52,20 @@
>  		reg = <0x20000000 0x04000000>;
>  	};
>  
> +	clocks {

[...]

> +
> +					tcb0_clk: tcb0_clk {
> +						#clock-cells = <0>;
> +						reg = <17>;
> +					};
> +
> +					tcb1_clk: tcb1_clk {
> +						#clock-cells = <0>;
> +						reg = <18>;
> +					};
> +
> +					tcb2_clk: tcb2_clk {
> +						#clock-cells = <0>;
> +						reg = <19>;
> +					};
> +
> +					tcb3_clk: tcb3_clk {
> +						#clock-cells = <0>;
> +						reg = <20>;
> +					};
> +
> +					tcb4_clk: tcb4_clk {
> +						#clock-cells = <0>;
> +						reg = <21>;
> +					};
> +
> +					tcb5_clk: tcb5_clk {
> +						#clock-cells = <0>;
> +						reg = <22>;
> +					};

Just a nitpick, but the names defined in at91rm9200.c and in the
datasheet are tcX_clk and not tcbX_clk.

Best Regards,

Boris



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
