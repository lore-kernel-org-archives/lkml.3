Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3EMUIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:08:21 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4904 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3EMUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:08:18 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <519147C6.6080004@broadcom.com>
Date: Mon, 13 May 2013 13:06:30 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130404
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Maxime Ripard" <maxime.ripard@free-electrons.com>
cc: "Michal Simek" <michal.simek@xilinx.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Simon Horman" <horms@verge.net.au>,
        "Magnus Damm" <magnus.damm@gmail.com>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "David Brown" <davidb@codeaurora.org>,
        "Jason Cooper" <jason@lakedaemon.net>, "Andrew Lunn" <andrew@lunn.ch>,
        "Gregory Clement" <gregory.clement@free-electrons.com>,
        "Shawn Guo" <shawn.guo@linaro.org>, "Barry Song" <baohua.song@csr.com>,
        "Tony Prisk" <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Arnd Bergmann" <arnd@arndb.de>, "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH 06/14] ARM: bcm281xx: Remove init_irq declaration in
 machine description
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368438253-28218-7-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368438253-28218-7-git-send-email-maxime.ripard@free-electrons.com>
X-WSS-ID: 7D8F996B1R014025910-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-05-13 02:44 AM, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for bcm281xx as well.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   arch/arm/mach-bcm/board_bcm.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm.c
> index 22e8421..24556cf 100644
> --- a/arch/arm/mach-bcm/board_bcm.c
> +++ b/arch/arm/mach-bcm/board_bcm.c
> @@ -54,7 +54,6 @@ static void __init board_init(void)
>   static const char * const bcm11351_dt_compat[] = { "bcm,bcm11351", NULL, };
>   
>   DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
> -	.init_irq = irqchip_init,
>   	.init_time = clocksource_of_init,
>   	.init_machine = board_init,
>   	.dt_compat = bcm11351_dt_compat,
Acked-by: Christian Daudt <csd@broadcom.com>


  thanks,
    csd


