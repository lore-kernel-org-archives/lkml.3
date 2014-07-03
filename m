Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbaGCEh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:37:59 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59520 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGCEh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
Date: Thu, 3 Jul 2014 12:37:57 +0800
Message-ID: <CAN1soZy+0JpM3fhga6bVFr8q=Viy-V8cPMuFJT_z9jSNKj6+7g@mail.gmail.com>
Subject: Re: [PATCH 1/3] clocksource: move PXA timer to clocksource framework
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 6:09 AM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Move time.c from arch/arm/mach-pxa/time.c to
> drivers/clocksource/pxa_timer.c.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  arch/arm/mach-pxa/Makefile                                  | 2 +-
>  drivers/clocksource/Makefile                                | 1 +
>  arch/arm/mach-pxa/time.c => drivers/clocksource/pxa_timer.c | 0
>  3 files changed, 2 insertions(+), 1 deletion(-)
>  rename arch/arm/mach-pxa/time.c => drivers/clocksource/pxa_timer.c (100%)
>
> diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
> index 648867a..2fe1824 100644
> --- a/arch/arm/mach-pxa/Makefile
> +++ b/arch/arm/mach-pxa/Makefile
> @@ -4,7 +4,7 @@
>
>  # Common support (must be linked before board specific support)
>  obj-y                          += clock.o devices.o generic.o irq.o \
> -                                  time.o reset.o
> +                                  reset.o
>  obj-$(CONFIG_PM)               += pm.o sleep.o standby.o
>
>  # Generic drivers that other drivers may depend upon
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 98cb6c5..e224125 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_ARCH_BCM2835)    += bcm2835_timer.o
>  obj-$(CONFIG_ARCH_MARCO)       += timer-marco.o
>  obj-$(CONFIG_ARCH_MOXART)      += moxart_timer.o
>  obj-$(CONFIG_ARCH_MXS)         += mxs_timer.o
> +obj-$(CONFIG_ARCH_PXA)         += pxa_timer.o
>  obj-$(CONFIG_ARCH_PRIMA2)      += timer-prima2.o
>  obj-$(CONFIG_ARCH_U300)                += timer-u300.o
>  obj-$(CONFIG_SUN4I_TIMER)      += sun4i_timer.o
> diff --git a/arch/arm/mach-pxa/time.c b/drivers/clocksource/pxa_timer.c
> similarity index 100%
> rename from arch/arm/mach-pxa/time.c
> rename to drivers/clocksource/pxa_timer.c
> --
> 2.0.0.rc2
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Acked for all these three patches.

Regards
Haojian
