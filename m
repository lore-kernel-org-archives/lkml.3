Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaGJSyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:54:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:37361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaGJSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:54:47 -0400
Message-ID: <53BEE172.4050208@infradead.org>
Date: Thu, 10 Jul 2014 11:54:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: Docbook: Fix files location change of
 kernel/[hr]timer.c in device-drivers.tmpl
References: <1405017830-31194-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1405017830-31194-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 11:43 AM, Masanari Iida wrote:
> make xmldocs failed because of file location change
> from kernel/[hr]timer.c to kernel/time/[hr]timer.c.

When does this change happen?  I don't see it in Linus's current git tree.

Thanks.

> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/DocBook/device-drivers.tmpl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index dd3f278..f213058 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -54,7 +54,7 @@
>  !Ikernel/sched/cpupri.c
>  !Ikernel/sched/fair.c
>  !Iinclude/linux/completion.h
> -!Ekernel/timer.c
> +!Ekernel/time/timer.c
>       </sect1>
>       <sect1><title>Wait queues and Wake events</title>
>  !Iinclude/linux/wait.h
> @@ -63,7 +63,7 @@
>       <sect1><title>High-resolution timers</title>
>  !Iinclude/linux/ktime.h
>  !Iinclude/linux/hrtimer.h
> -!Ekernel/hrtimer.c
> +!Ekernel/time/hrtimer.c
>       </sect1>
>       <sect1><title>Workqueues and Kevents</title>
>  !Ekernel/workqueue.c
> 


-- 
~Randy
