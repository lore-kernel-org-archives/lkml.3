Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3FDP0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:26:39 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:59668
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab3FDP0g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:26:36 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dIc89bh936eI1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <1370359730.16167.4.camel@linux-builds1>
Subject: Re: [PATCH v2 0/4] dw_apb_timer: osc as sched_clock, clocks and
 clocksource_of support
From: Dinh Nguyen <dinguyen@altera.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Grant Likely <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
Date: Tue, 4 Jun 2013 10:28:50 -0500
In-Reply-To: <201306041136.09566.heiko@sntech.de>
References: <201306041136.09566.heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Tue, 2013-06-04 at 11:36 +0200, Heiko Stübner wrote:
> This is split off of my Rockchip support series from yesterday. It's now
> a patch more than before, as the third patch enables the timer to be used
> thru clocksource_of_init and moves picoxcell and socfpga to it.
> 
> changes since v1:
> - hopefully improve the patch description of patch 1
>   after a suggestion by Linus Walleij
> - move the selection of DW_APB_TIMER and CLKSRC_OF into DW_APB_TIMER_OF
>   after a suggestion by Baruch Siach
> 
> Heiko Stuebner (4):
>   clocksource: dw_apb_timer_of: enable the use the clocksource as sched clock
>   clocksource: dw_apb_timer_of: add clock-handling
>   clocksource: dw_apb_timer_of: select DW_APB_TIMER
>   clocksource: dw_apb_timer_of: use clocksource_of_init
> 
>  Documentation/devicetree/bindings/rtc/dw-apb.txt |   19 +++++
>  arch/arm/mach-picoxcell/Kconfig                  |    1 -
>  arch/arm/mach-picoxcell/common.c                 |    2 -
>  arch/arm/mach-socfpga/Kconfig                    |    1 -
>  arch/arm/mach-socfpga/socfpga.c                  |    2 -
>  drivers/clocksource/Kconfig                      |    2 +
>  drivers/clocksource/dw_apb_timer_of.c            |   95 ++++++++++++++-------
>  include/linux/dw_apb_timer.h                     |    1 -
>  8 files changed, 84 insertions(+), 39 deletions(-)
> 

For all the mach-socfpga parts:

Acked-by: Dinh Nguyen <dinguyen@altera.com>

Thanks,
Dinh


