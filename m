Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3LBOfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:35:39 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42398 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3LBOff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:35:35 -0500
Date: Mon, 2 Dec 2013 15:35:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf script: Print comm, fork and exit events
 also
Message-ID: <20131202143530.GA6758@localhost.localdomain>
References: <1385455873-25865-1-git-send-email-namhyung@kernel.org>
 <tip-ad7ebb9a48f59bad2714b64725653a73d78b686e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ad7ebb9a48f59bad2714b64725653a73d78b686e@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 04:53:07AM -0800, tip-bot for Namhyung Kim wrote:
> Commit-ID:  ad7ebb9a48f59bad2714b64725653a73d78b686e
> Gitweb:     http://git.kernel.org/tip/ad7ebb9a48f59bad2714b64725653a73d78b686e
> Author:     Namhyung Kim <namhyung@kernel.org>
> AuthorDate: Tue, 26 Nov 2013 17:51:12 +0900
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Wed, 27 Nov 2013 14:58:38 -0300
> 
> perf script: Print comm, fork and exit events also
> 
> If --show-task-events option is given, also print internal COMM, FORK
> and EXIT events.  It would be helpful for debugging.
> 
>   $ perf script --show-task-events
>   ...
>          swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
>            sleep  9486 [009] 3350640.335509: PERF_RECORD_COMM: sleep:9486
>            sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
>          firefox  2635 [003] 3350641.275896: PERF_RECORD_FORK(2635:9487):(2635:2635)
>          firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
>            sleep  9486 [009] 3350641.336009: PERF_RECORD_EXIT(9486:9486):(9486:9486)
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks a lot for doing this Namhyung!
