Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaJAQZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:25:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54819 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaJAQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <1412157898-7040-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <CAF0htA4B=jhBu_YmSTj9=BQ-m3_UGRggwop5ZtgPbO9Y45V+aA@mail.gmail.com>
	<1412157898-7040-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Thu, 2 Oct 2014 00:25:07 +0800
Message-ID: <CAF0htA7Bs-wMp55G1xYR6iPSZ6vZ2Nsc9peL19Pqicf=jrGUAw@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] score: remove deprecated IRQF_DISABLED
From: Lennox Wu <lennox.wu@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Liqin Chen <liqin.linux@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,
I will merge it and then issue a PULL request this weekend.
Thanks.

2014-10-01 18:04 GMT+08:00 Michael Opdenacker
<michael.opdenacker@free-electrons.com>:
> This patch removes the use of the IRQF_DISABLED flag
> from arch/score/kernel/time.c
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Acked-by: Lennox Wu <lennox.wu@gmail.com>
> ---
>  arch/score/kernel/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
> index f0a43affb201..24770cd9b473 100644
> --- a/arch/score/kernel/time.c
> +++ b/arch/score/kernel/time.c
> @@ -41,7 +41,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
>
>  static struct irqaction timer_irq = {
>         .handler = timer_interrupt,
> -       .flags = IRQF_DISABLED | IRQF_TIMER,
> +       .flags = IRQF_TIMER,
>         .name = "timer",
>  };
>
> --
> 1.9.1
>
