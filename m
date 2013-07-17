Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3GQS5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:57:38 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39705 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab3GQS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:57:35 -0400
Message-ID: <51E6E91C.1090700@linaro.org>
Date: Wed, 17 Jul 2013 11:57:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add the generic sched_clock under timekeeping
References: <a38977cc6608170b69b21b8a5ee985685c7e8a0d.1374055149.git.baruch@tkos.co.il>
In-Reply-To: <a38977cc6608170b69b21b8a5ee985685c7e8a0d.1374055149.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 03:05 AM, Baruch Siach wrote:
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bf61e04..bd9616a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7129,6 +7129,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
>   S:	Supported
>   F:	include/linux/clocksource.h
> +F:	include/linux/sched_clock.h
>   F:	include/linux/time.h
>   F:	include/linux/timex.h
>   F:	include/uapi/linux/time.h
> @@ -7136,6 +7137,7 @@ F:	include/uapi/linux/timex.h
>   F:	kernel/time/clocksource.c
>   F:	kernel/time/time*.c
>   F:	kernel/time/ntp.c
> +F:	kernel/time/sched_clock.c

It seems like we could probably simplify this bit to kernel/time/*, no?

thanks
-john


