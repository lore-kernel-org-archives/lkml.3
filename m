Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3C2KeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:34:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33994 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3C2KeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:34:18 -0400
Message-ID: <1364553251.5053.83.camel@laptop>
Subject: Re: [PATCH v2 0/7] sched: Split cpuacct
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 29 Mar 2013 11:34:11 +0100
In-Reply-To: <5155365F.1010203@huawei.com>
References: <5155365F.1010203@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 14:36 +0800, Li Zefan wrote:

> - This patchset splits cpuacct out of core scheduler code.
> - Plus two small optimizations.
> 

> ---
>  kernel/sched/Makefile  |   1 +
>  kernel/sched/core.c    | 228 +----------------------------------------------
>  kernel/sched/cpuacct.c | 303 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/cpuacct.h |  22 +++++
>  kernel/sched/cputime.c |  18 +---
>  kernel/sched/sched.h   |  48 +---------
>  6 files changed, 330 insertions(+), 290 deletions(-)

Looks good from a quick glance, thanks for doing this.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

