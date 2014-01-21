Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaAUHnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 02:43:32 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:60702 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaAUHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 02:43:26 -0500
MIME-Version: 1.0
In-Reply-To: <1390282399-17091-2-git-send-email-alex.shi@linaro.org>
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
	<1390282399-17091-2-git-send-email-alex.shi@linaro.org>
Date: Mon, 20 Jan 2014 23:43:24 -0800
X-Google-Sender-Auth: UlSQQ5vyVKu8twb3qhmjNT1Hfn8
Message-ID: <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
From: Jason Low <jason.low2@hp.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, Mike Galbraith <efault@gmx.de>,
        wangyun@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 9:33 PM, Alex Shi <alex.shi@linaro.org> wrote:
> It's useful to track this value in debug mode.
>
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/debug.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 1e43e70..f5c529a 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -315,6 +315,7 @@ do {                                                                        \
>         P(sched_goidle);
>  #ifdef CONFIG_SMP
>         P64(avg_idle);
> +       p64(max_idle_balance_cost);

Hi Alex,

Does this need to be P64(max_idle_balance_cost)?
