Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaGOAJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:09:53 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:42494 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaGOAJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:09:51 -0400
Message-ID: <53C4714C.8000103@mvista.com>
Date: Mon, 14 Jul 2014 19:09:48 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/3] Linux 3.10.47-rt50-rc1
References: <20140714200420.805309842@goodmis.org>
In-Reply-To: <20140714200420.805309842@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we get:

tracing-use-migrate_disable-to-prevent-beeing-pushed.patch

into 3.10, also?

Thanks,

-corey

On 07/14/2014 03:04 PM, Steven Rostedt wrote:
> Dear RT Folks,
>
> This is the RT stable review cycle of patch 3.10.47-rt50-rc1.
>
> Please scream at me if I messed something up. Please test the patches too.
>
> The -rc release will be uploaded to kernel.org and will be deleted when
> the final release is out. This is just a review release (or release candidate).
>
> The pre-releases will not be pushed to the git repository, only the
> final release is.
>
> If all goes well, this patch will be converted to the next main release
> on 7/17/2014.
>
> Enjoy,
>
> -- Steve
>
>
> To build 3.10.47-rt50-rc1 directly, the following patches should be applied:
>
>   http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz
>
>   http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.47.xz
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.47-rt50-rc1.patch.xz
>
> You can also build from 3.10.47-rt49 by applying the incremental patch:
>
> http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.47-rt49-rt50-rc1.patch.xz
>
>
> Changes from 3.10.47-rt49:
>
> ---
>
>
> Steven Rostedt (1):
>       sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq()
>
> Steven Rostedt (Red Hat) (1):
>       Linux 3.10.47-rt50-rc1
>
> Thomas Gleixner (1):
>       workqueue: Prevent deadlock/stall on RT
>
> ----
>  kernel/sched/core.c | 13 +++++-------
>  kernel/workqueue.c  | 61 +++++++++++++++++++++++++++++++++++++++++------------
>  localversion-rt     |  2 +-
>  3 files changed, 54 insertions(+), 22 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

