Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3ENDag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:30:36 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:17068
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3ENDaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:30:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z37d4lz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 14 May 2013 11:30:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: mxs: remove the .map_io declaration
Message-ID: <20130514033050.GB16250@S2101-09.ap.freescale.net>
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368440169-29088-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1368440169-29088-4-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 12:16:08PM +0200, Maxime Ripard wrote:
> Now that the ARM core code calls debug_ll_io_init, we can remove it from
> the machine_desc declaration.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  arch/arm/mach-mxs/mach-mxs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
> index 5b62b64..d67ecc1 100644
> --- a/arch/arm/mach-mxs/mach-mxs.c
> +++ b/arch/arm/mach-mxs/mach-mxs.c
> @@ -434,7 +434,6 @@ static const char *mxs_dt_compat[] __initdata = {
>  };
>  
>  DT_MACHINE_START(MXS, "Freescale MXS (Device Tree)")
> -	.map_io		= debug_ll_io_init,
>  	.init_irq	= irqchip_init,
>  	.handle_irq	= icoll_handle_irq,
>  	.init_time	= mxs_timer_init,
> -- 
> 1.8.1.2
> 

