Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3AUSWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:22:05 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40863 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008Ab3AUSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:22:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18cjD+8p9Pc8FyFHm6GiEba
Date: Mon, 21 Jan 2013 10:21:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: peter.ujfalusi@ti.com, balbi@ti.com, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] OMAP: omap4-panda: add UART2 muxing for WiLink shared
 transport
Message-ID: <20130121182158.GD22517@atomide.com>
References: <1358766852-24503-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358766852-24503-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [130121 03:18]:
> Add the UART2 muxing data to the board file (this used to be,
> erroneously, done in the bootloader).
> 
> Cc: stable <stable@vger.kernel.org> [3.7]
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Thanks applying into omap-for-v3.8-rc4/fixes.

Regards,

Tony

> ---
>  arch/arm/mach-omap2/board-omap4panda.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
> index 5c8e9ce..769c1fe 100644
> --- a/arch/arm/mach-omap2/board-omap4panda.c
> +++ b/arch/arm/mach-omap2/board-omap4panda.c
> @@ -397,6 +397,12 @@ static struct omap_board_mux board_mux[] __initdata = {
>  		  OMAP_PULL_ENA),
>  	OMAP4_MUX(ABE_MCBSP1_FSX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
>  
> +	/* UART2 - BT/FM/GPS shared transport */
> +	OMAP4_MUX(UART2_CTS,	OMAP_PIN_INPUT	| OMAP_MUX_MODE0),
> +	OMAP4_MUX(UART2_RTS,	OMAP_PIN_OUTPUT	| OMAP_MUX_MODE0),
> +	OMAP4_MUX(UART2_RX,	OMAP_PIN_INPUT	| OMAP_MUX_MODE0),
> +	OMAP4_MUX(UART2_TX,	OMAP_PIN_OUTPUT	| OMAP_MUX_MODE0),
> +
>  	{ .reg_offset = OMAP_MUX_TERMINATOR },
>  };
>  
> -- 
> 1.7.10.4
> 
