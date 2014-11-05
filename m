Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaKEOKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:10:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:44418 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753916AbaKEOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:10:37 -0500
Date: Wed, 5 Nov 2014 09:10:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: move p->nr_cpus_allowed to select_task_rq
Message-ID: <20141105091020.1ac30239@gandalf.local.home>
In-Reply-To: <1415150077-59053-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1415150077-59053-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Nov 2014 09:14:37 +0800
Wanpeng Li <wanpeng.li@linux.intel.com> wrote:

> Move p->nr_cpus_allowed check into kernel/sched/core.c: select_task_rq().
> This change will make fair.c, rt.c, and deadline.c all start with the 
> same logic.
> 

Link: http://lkml.kernel.org/r/20141104094549.59acebb6@gandalf.local.home

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/core.c     | 3 ++-
>  kernel/sched/deadline.c | 3 ---
>  kernel/sched/fair.c     | 3 ---
>  kernel/sched/rt.c       | 3 ---
>  4 files changed, 2 insertions(+), 10 deletions(-)
> 
>
