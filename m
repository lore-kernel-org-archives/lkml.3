Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaCYKf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:35:58 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34266 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaCYKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <8af4518de872a12afe063edd72e209fe60423280.1395739927.git.viresh.kumar@linaro.org>
References: <8af4518de872a12afe063edd72e209fe60423280.1395739927.git.viresh.kumar@linaro.org>
Date: Tue, 25 Mar 2014 12:35:55 +0200
Message-ID: <CADmjqpMqdN0kRA3ee9D8NkDHGrMcXPJKn9XYj+nXp8yYhqH1=A@mail.gmail.com>
Subject: Re: [PATCH] tick: fix spelling mistake in tick_handle_periodic()
From: Stratos Karafotis <skarafotis@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 11:32 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> One of the comments in tick_handle_periodic() had 'when' instead of 'which' (My
> guess :)). Fix it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/time/tick-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 20b2fe3..791a3a2 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -118,7 +118,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
>                  * to be sure we're using a real hardware clocksource.
>                  * Otherwise we could get trapped in an infinite
>                  * loop, as the tick_periodic() increments jiffies,
> -                * when then will increment time, posibly causing
> +                * which then will increment time, posibly causing

Also, on the same line
s/posibly/possibly


Stratos
