Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaGKKsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:48:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34641 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751174AbaGKKr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:47:58 -0400
Date: Fri, 11 Jul 2014 12:47:56 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        jiri.prchal@aksignal.cz, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: add clocks for usb device
Message-ID: <20140711104755.GA3112@piout.net>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 at 18:22:55 +0800, Bo Shen wrote :
> Add clocks for usb device, or else switch to CCF, the gadget
> won't work.
> 
> Reported-by: Jiří Prchal <jiri.prchal@aksignal.cz>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  arch/arm/boot/dts/at91sam9x5.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index d6133f4..2ebc421 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -1045,6 +1045,8 @@
>  				reg = <0x00500000 0x80000
>  				       0xf803c000 0x400>;
>  				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&usb>, <&udphs_clk>;
> +				clock-names = "hclk", "pclk";
>  				status = "disabled";
>  
>  				ep0 {
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
