Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaKDRCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:02:36 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:34397 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKDRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:02:35 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 4 Nov 2014 12:02:33 -0500
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
Message-ID: <20141104170233.GB24112@csclub.uwaterloo.ca>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <1412014009-13315-12-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412014009-13315-12-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:06:47PM +0200, Sebastian Andrzej Siewior wrote:
> Cc: devicetree@vger.kernel.org
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/arm/boot/dts/dra7.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index d678152db4cb..f273e3811f75 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -332,6 +332,8 @@
>  			ti,hwmods = "uart1";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> +			dmas = <&sdma 49>, <&sdma 50>;
> +			dma-names = "tx", "rx";
>  		};
>  
>  		uart2: serial@4806c000 {
> @@ -341,6 +343,8 @@
>  			ti,hwmods = "uart2";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> +			dmas = <&sdma 51>, <&sdma 52>;
> +			dma-names = "tx", "rx";
>  		};
>  
>  		uart3: serial@48020000 {
> @@ -350,6 +354,8 @@
>  			ti,hwmods = "uart3";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> +			dmas = <&sdma 53>, <&sdma 54>;
> +			dma-names = "tx", "rx";
>  		};
>  
>  		uart4: serial@4806e000 {
> @@ -359,6 +365,8 @@
>  			ti,hwmods = "uart4";
>  			clock-frequency = <48000000>;
>                          status = "disabled";
> +			dmas = <&sdma 55>, <&sdma 56>;
> +			dma-names = "tx", "rx";
>  		};
>  
>  		uart5: serial@48066000 {
> @@ -368,6 +376,8 @@
>  			ti,hwmods = "uart5";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> +			dmas = <&sdma 63>, <&sdma 64>;
> +			dma-names = "tx", "rx";
>  		};
>  
>  		uart6: serial@48068000 {
> @@ -377,6 +387,8 @@
>  			ti,hwmods = "uart6";
>  			clock-frequency = <48000000>;
>  			status = "disabled";
> +			dmas = <&sdma 79>, <&sdma 80>;
> +			dma-names = "tx", "rx";
>  		};
>  
>  		uart7: serial@48420000 {

According to the manual the DMA channels for UART7 to 10 are:

uart7:  144 145
uart8:  146 147
uart9:  148 149
uart10: 150 151

Might as well add those too.  We have uart 7 and 8 in use on our board
so I am about to go test it.

-- 
Len Sorensen
