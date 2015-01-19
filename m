Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbbASV3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:29:37 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:58118 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbASV3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:29:35 -0500
Date: Mon, 19 Jan 2015 22:27:18 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-next] ARM: mvebu: make DTS comments reflect
 DEBUG_LL changes
Message-ID: <20150119212718.GA2938@lunn.ch>
References: <1421696425.9655.65.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421696425.9655.65.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 08:40:25PM +0100, Paul Bolle wrote:
> The Kconfig symbol DEBUG_MVEBU_UART_ALTERNATE was renamed to
> DEBUG_MVEBU_UART0_ALTERNATE. And the symbol DEBUG_MVEBU_UART1_ALTERNATE
> was added to allow UART1 as a DEBUG_LL target. Make the comment at the
> top of this DTS reflect those changes.
> 
> Since we're touching this DTS add comments to show which blocks describe
> UART0 and UART1.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Hi Paul

Thanks for this. I have added it to mvebu/dt.

       Andrew


> ---
> Created on top of next-20150119. Untested! Note that I know nothing
> about this board or about DT source files, so all changes are nothing
> more than guesses.
> 
>  arch/arm/boot/dts/armada-xp-axpwifiap.dts | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/armada-xp-axpwifiap.dts b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
> index ca0200e20751..28174ab019f9 100644
> --- a/arch/arm/boot/dts/armada-xp-axpwifiap.dts
> +++ b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
> @@ -3,8 +3,8 @@
>   *
>   * Note: this board is shipped with a new generation boot loader that
>   * remaps internal registers at 0xf1000000. Therefore, if earlyprintk
> - * is used, the CONFIG_DEBUG_MVEBU_UART_ALTERNATE option should be
> - * used.
> + * is used, the CONFIG_DEBUG_MVEBU_UART0_ALTERNATE option or the
> + * CONFIG_DEBUG_MVEBU_UART1_ALTERNATE option should be used.
>   *
>   * Copyright (C) 2013 Marvell
>   *
> @@ -60,10 +60,12 @@
>  		};
>  
>  		internal-regs {
> +			/* UART0 */
>  			serial@12000 {
>  				status = "okay";
>  			};
>  
> +			/* UART1 */
>  			serial@12100 {
>  				status = "okay";
>  			};
> -- 
> 1.9.3
> 
