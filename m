Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab3JLEqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:46:30 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37572 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3JLEq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <1381549451-5362-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381549451-5362-1-git-send-email-michael.opdenacker@free-electrons.com>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Sat, 12 Oct 2013 12:46:08 +0800
Message-ID: <CAKT61h8QGU0ZZhms9WgMmyWhEmB_odTOfD0guihf6TfRpZ2YUw@mail.gmail.com>
Subject: Re: [PATCH] ARM: w90x900: remove deprecated IRQF_DISABLED
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/12 Michael Opdenacker <michael.opdenacker@free-electrons.com>:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Wan zongshun <mcuos.com@gmail.com>

Thanks!

> ---
>  arch/arm/mach-w90x900/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
> index 30fbca8..9230d37 100644
> --- a/arch/arm/mach-w90x900/time.c
> +++ b/arch/arm/mach-w90x900/time.c
> @@ -111,7 +111,7 @@ static irqreturn_t nuc900_timer0_interrupt(int irq, void *dev_id)
>
>  static struct irqaction nuc900_timer0_irq = {
>         .name           = "nuc900-timer0",
> -       .flags          = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +       .flags          = IRQF_TIMER | IRQF_IRQPOLL,
>         .handler        = nuc900_timer0_interrupt,
>  };
>
> --
> 1.8.1.2
>



-- 
Wan ZongShun.
www.mcuos.com
