Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3KNKbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:31:40 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:55668 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3KNKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:31:38 -0500
MIME-Version: 1.0
In-Reply-To: <1381479838-7794-2-git-send-email-zhangwm@marvell.com>
References: <1381479838-7794-1-git-send-email-zhangwm@marvell.com>
	<1381479838-7794-2-git-send-email-zhangwm@marvell.com>
Date: Thu, 14 Nov 2013 18:31:37 +0800
Message-ID: <CAN1soZz70dykX=FEBQY2Q0neN1-nCKt=JhL2HZq4tdJ5BvtZYw@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] irqchip: mmp: avoid use head file in a specific arch
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 4:23 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> For example, arm64 doesn't have mach/irq.h.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
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

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Thomas,
Could you help to pick up this patch into your git tree?

Best Regards
Haojian
