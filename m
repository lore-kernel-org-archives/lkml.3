Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3GJSuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:50:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56565 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752571Ab3GJSuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:50:12 -0400
Message-ID: <1373482211.14604.62.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Add Daniel as maintainer for
 drivers/clocksource
From: Joe Perches <joe@perches.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Date: Wed, 10 Jul 2013 11:50:11 -0700
In-Reply-To: <51DDA797.4030200@linaro.org>
References: <51DDA797.4030200@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 19:27 +0100, John Stultz wrote:
> I've been doing a bad job at managing the drivers/clocksource directory,
> so Daniel has been helping with review and patch queuing for the clocksource
> and clockevent drivers, so add him formally to the MAINTAINERS list.
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>   MAINTAINERS | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5be702c..460c996 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7014,6 +7014,12 @@ F:	include/uapi/linux/timex.h
>   F:	kernel/time/clocksource.c
>   F:	kernel/time/time*.c
>   F:	kernel/time/ntp.c
> +
> +CLOCKSOURCE, CLOCKEVENT DRIVERS
> +M:	Daniel Lezcano <daniel.lezcano@linaro.org>
> +M:	Thomas Gleixner <tglx@linutronix.de>
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> +S:	Supported
>   F:	drivers/clocksource

Sections in alphabetical order please.

Does this even apply?
It looks more like an interdiff.

Should the F: include/linux/clocksource.h
and F: kernel/time/clocksource.c entries
above this be moved too?

