Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBNJXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:23:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57689 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaBNJXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:23:46 -0500
X-IronPort-AV: E=Sophos;i="4.95,843,1384272000"; 
   d="scan'208";a="9527123"
Message-ID: <52FDE06A.1020909@cn.fujitsu.com>
Date: Fri, 14 Feb 2014 17:22:50 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/9] Add MAX_NICE, MIN_NICE and NICE_WIDTH macros in prio.h.
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/14 17:21:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/14 17:21:41,
	Serialize complete at 2014/02/14 17:21:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo & Peter,
     What's your opinion on this patchset?

On 02/11/2014 03:34 PM, Dongsheng Yang wrote:
> Hi Peter,
> 	There are lots of hardcoding of -20 and 19 in kernel to represent
> minimum and maximum of nice value currently. This patch set define three
> macros in prio.h and replace some of the hardcoding with them.
>
> 	Please help to take a look at it, thanx :)
>
> Dongsheng Yang (9):
>    sched: Prio: Use DEFAULT_PRIO to define NICE_TO_PRIO and PRIO_TO_NICE.
>    sched: prio: Add 3 macros of MAX_NICE, MIN_NICE and NICE_WIDTH in
>      prio.h.
>    sched: prio: Use NICE_WIDTH macro to avoid using of hard coding of 40
>      and 20 in prio.h.
>    sched: prio: Add spaces before and after operator of '-'.
>    rcu: Use MAX_NICE to replace hard coding of 19.
>    sched: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
>    sys: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
>    workqueue: Replace hardcoding of -20 and 19 with MIN_NICE and
>      MAX_NICE.
>    trace: Replace hardcoding of 19 with MAX_NICE.
>
>   include/linux/sched/prio.h           | 14 +++++++++-----
>   kernel/rcu/torture.c                 |  8 ++++----
>   kernel/sched/auto_group.c            |  2 +-
>   kernel/sched/core.c                  | 12 ++++++------
>   kernel/sys.c                         |  8 ++++----
>   kernel/trace/ring_buffer_benchmark.c |  6 +++---
>   kernel/workqueue.c                   |  2 +-
>   7 files changed, 28 insertions(+), 24 deletions(-)
>

