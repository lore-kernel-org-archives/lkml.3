Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaGNGOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:14:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44002 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbaGNGOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:14:25 -0400
Date: Mon, 14 Jul 2014 08:14:21 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: at91sam9x5: correct typo error for ohci
 clock
Message-ID: <20140714081421.5f539287@bbrezillon>
In-Reply-To: <1405307294-17708-1-git-send-email-voice.shen@atmel.com>
References: <1405307294-17708-1-git-send-email-voice.shen@atmel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 11:08:14 +0800
Bo Shen <voice.shen@atmel.com> wrote:

> Correct the typo error for the second "uhphs_clk".
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

sam9n12 dtsi has the same bug, I'll fix it

And sorry for the mess when moving sam9n12 and sam9x5 to the CCF, I
should have checked my clock definitions more carefully :-(.

Best Regards,

Bros

> ---
>  arch/arm/boot/dts/at91sam9x5.dtsi | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index 2ebc421..727d3a4 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -1155,8 +1155,7 @@
>  			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
>  			reg = <0x00600000 0x100000>;
>  			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
> -			clocks = <&usb>, <&uhphs_clk>, <&udphs_clk>,
> -				 <&uhpck>;
> +			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
>  			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
>  			status = "disabled";
>  		};



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
