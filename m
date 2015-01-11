Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbbAKOpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:45:39 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53289 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbAKOpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:45:38 -0500
MIME-Version: 1.0
In-Reply-To: <1419370391-15027-1-git-send-email-festevam@gmail.com>
References: <1419370391-15027-1-git-send-email-festevam@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 11 Jan 2015 22:45:16 +0800
X-Google-Sender-Auth: NpmcXMskWUWqpuO4H0LJZ5cMRWM
Message-ID: <CAGsJ_4zG1ATSbLJ-Zw1YhP9FqVEBaBg0qY=4Or+N1i23bD7MAQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sirf: Remove unused variable
To: Fabio Estevam <festevam@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-24 5:33 GMT+08:00 Fabio Estevam <festevam@gmail.com>:
> Remove 'timer_div' variable to fix the following build warning:
>
> drivers/clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
> drivers/clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div' [-Wunused-variable]
>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

thanks. but this has been handled by:

http://permalink.gmane.org/gmane.linux.ports.arm.kernel/382514

> ---
>  drivers/clocksource/timer-marco.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
> index 361a789..3ddb81f 100644
> --- a/drivers/clocksource/timer-marco.c
> +++ b/drivers/clocksource/timer-marco.c
> @@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
>  /* initialize the kernel jiffy timer source */
>  static void __init sirfsoc_marco_timer_init(struct device_node *np)
>  {
> -       u32 timer_div;
>         struct clk *clk;
>
>         clk = of_clk_get(np, 0);
> --
> 1.9.1
>

-barry
