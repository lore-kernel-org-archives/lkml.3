Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3JBMru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:47:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19674 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3JBMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:47:48 -0400
Message-ID: <524C15F5.5030704@atmel.com>
Date: Wed, 2 Oct 2013 14:47:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: at91/tc/clocksource: remove IRQF_DISABLED
References: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com> <1380717348-6650-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1380717348-6650-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 14:35, Boris BREZILLON :
> Remove the deprecated IRQF_DISABLED flag.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/clocksource/tcb_clksrc.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> index 10a5d9e..00fdd11 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -180,7 +180,7 @@ static irqreturn_t ch2_irq(int irq, void *handle)
>
>   static struct irqaction tc_irqaction = {
>   	.name		= "tc_clkevt",
> -	.flags		= IRQF_TIMER | IRQF_DISABLED,
> +	.flags		= IRQF_TIMER,
>   	.handler	= ch2_irq,
>   };
>
>


-- 
Nicolas Ferre
