Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaCEDIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:08:16 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:41256 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbaCEDIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <1393967856-17938-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386567048-19855-1-git-send-email-michael.opdenacker@free-electrons.com>
	<1393967856-17938-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Wed, 5 Mar 2014 11:08:14 +0800
Message-ID: <CAF0htA4B=jhBu_YmSTj9=BQ-m3_UGRggwop5ZtgPbO9Y45V+aA@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] score: remove deprecated IRQF_DISABLED
From: Lennox Wu <lennox.wu@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Liqin Chen <liqin.linux@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for cleaning the code.

Acked-by: Lennox Wu<lennox.wu@gmail.com>

2014-03-05 5:17 GMT+08:00 Michael Opdenacker
<michael.opdenacker@free-electrons.com>:
> This patch removes the use of the IRQF_DISABLED flag
> from arch/score/kernel/time.c
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
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
> 1.8.3.2
>
