Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaBTOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:09:28 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:47864 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaBTOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <1386326807-21688-1-git-send-email-zhangwm@marvell.com>
References: <1386326807-21688-1-git-send-email-zhangwm@marvell.com>
Date: Thu, 20 Feb 2014 22:09:25 +0800
Message-ID: <CAN1soZxcZ9FuKUeQLYEQxZaDR6CPXOA06bons08abpDDfmnS_w@mail.gmail.com>
Subject: Re: [PATCH v3] irqchip: mmp: avoid use head file in a specific arch
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>, Bergmann Arnd <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 6:46 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> For example, arm64 doesn't have mach/irq.h.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/irqchip/irq-mmp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
> index 2cb7cd0..470c5de 100644
> --- a/drivers/irqchip/irq-mmp.c
> +++ b/drivers/irqchip/irq-mmp.c
> @@ -22,7 +22,7 @@
>  #include <linux/of_irq.h>
>
>  #include <asm/exception.h>
> -#include <asm/mach/irq.h>
> +#include <asm/hardirq.h>
>
>  #include "irqchip.h"
>
> --
> 1.7.9.5
>

Hi Thomas,

Since this patch is pending for a lot of time, could you help to give
an Ack on this? Then I could push it into arm-soc tree.

Regards
Haojian
