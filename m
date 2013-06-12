Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3FLI4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:56:11 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57651 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab3FLI4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:56:09 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 0/4] dw_apb_timer: osc as sched_clock, clocks and clocksource_of support
Date: Wed, 12 Jun 2013 10:55:52 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>, Olof Johansson <olof@lixom.net>
References: <201306041136.09566.heiko@sntech.de>
In-Reply-To: <201306041136.09566.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306121055.53685.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Juni 2013, 11:36:09 schrieb Heiko Stübner:
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
>   clocksource: dw_apb_timer_of: enable the use the clocksource as sched
> clock clocksource: dw_apb_timer_of: add clock-handling
>   clocksource: dw_apb_timer_of: select DW_APB_TIMER
>   clocksource: dw_apb_timer_of: use clocksource_of_init
> 
>  Documentation/devicetree/bindings/rtc/dw-apb.txt |   19 +++++
>  arch/arm/mach-picoxcell/Kconfig                  |    1 -
>  arch/arm/mach-picoxcell/common.c                 |    2 -
>  arch/arm/mach-socfpga/Kconfig                    |    1 -
>  arch/arm/mach-socfpga/socfpga.c                  |    2 -
>  drivers/clocksource/Kconfig                      |    2 +
>  drivers/clocksource/dw_apb_timer_of.c            |   95
> ++++++++++++++------- include/linux/dw_apb_timer.h                     |  
>  1 -
>  8 files changed, 84 insertions(+), 39 deletions(-)

with clocksource_of conversion of picoxcell and socfpga, this series stands on 
its own. Is anybody going to pick it up?


Thanks
Heiko
