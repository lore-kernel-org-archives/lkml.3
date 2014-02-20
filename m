Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaBTUtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:49:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:34480 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaBTUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:49:44 -0500
Date: Thu, 20 Feb 2014 21:49:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, anton@enomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4 2/6] tracing/trivial: Add CLOCK_BOOTIME and CLOCK_TAI
 for human readable clockid trace
In-Reply-To: <1392913425-29369-3-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402202149200.4468@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-3-git-send-email-a.perevalov@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Alexey Perevalov wrote:

> These clockids is also used in current hrtimer implementation.

tracing/trivial ???

It's a functional patch related to tracing. 
 
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  include/trace/events/timer.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> index 185b2c6..547b79f 100644
> --- a/include/trace/events/timer.h
> +++ b/include/trace/events/timer.h
> @@ -11,7 +11,10 @@
>  #define clockid_to_string(clockid)						\
>  	__print_symbolic(clockid,						\
>  			 { CLOCK_MONOTONIC,		"CLOCK_MONOTONIC" },	\
> -			 { CLOCK_REALTIME,		"CLOCK_REALTIME" })
> +			 { CLOCK_REALTIME,		"CLOCK_REALTIME" },	\
> +			 { CLOCK_BOOTTIME,		"CLOCK_BOOTTIME" },	\
> +			 { CLOCK_TAI,			"CLOCK_TAI" }		\
> +	)
>  
>  #define hrmode_to_string(hrmode)						\
>  	__print_symbolic(hrmode,						\
> -- 
> 1.7.9.5
> 
> 
