Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaGMQx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 12:53:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaGMQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 12:53:18 -0400
Message-ID: <53C2B97D.8040003@infradead.org>
Date: Sun, 13 Jul 2014 09:53:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/1] doc: fix docbook generation
References: <53C19428.9040008@gmail.com>
In-Reply-To: <53C19428.9040008@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/14 13:01, Pranith Kumar wrote:
> kernel/timer.c and kernel/hrtimer.c have moved to kernel/time directory. This
> causes docbook generation to fail. The following commit fixes it by updating the
> references.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Already fixed in the timers tree (Thomas applied a patch from
Masanari Iida).

Thanks.

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
