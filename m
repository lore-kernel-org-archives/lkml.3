Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3EMMgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:36:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49292 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3EMMgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:36:04 -0400
Message-ID: <1368448558.3425.2.camel@hornet>
Subject: Re: [PATCH 12/14] ARM: vexpress: Remove init_irq declaration in
 machine description
From: Pawel Moll <pawel.moll@arm.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>, Arnd Bergmann <arnd@arndb.de>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 13 May 2013 13:35:58 +0100
In-Reply-To: <1368438253-28218-13-git-send-email-maxime.ripard@free-electrons.com>
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1368438253-28218-13-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: Evolution 3.6.4-0ubuntu1
Mime-Version: 1.0
X-OriginalArrivalTime: 13 May 2013 12:35:59.0984 (UTC) FILETIME=[6C5B4700:01CE4FD6]
X-MC-Unique: 113051313360112901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 10:44 +0100, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for vexpress as well.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-vexpress/v2m.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> index 8802030..c419b76 100644
> --- a/arch/arm/mach-vexpress/v2m.c
> +++ b/arch/arm/mach-vexpress/v2m.c
> @@ -458,7 +458,6 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
>  	.smp		= smp_ops(vexpress_smp_ops),
>  	.map_io		= v2m_dt_map_io,
>  	.init_early	= v2m_dt_init_early,
> -	.init_irq	= irqchip_init,
>  	.init_time	= v2m_dt_timer_init,
>  	.init_machine	= v2m_dt_init,
>  MACHINE_END

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Pawel


