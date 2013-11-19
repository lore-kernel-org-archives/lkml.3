Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3KSDQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:16:50 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9332 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3KSDQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:16:46 -0500
Message-ID: <1384831002.2459.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:sched/urgent] sched: Optimize task_sched_runtime()
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, pjt@google.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Date: Mon, 18 Nov 2013 19:16:42 -0800
In-Reply-To: <tip-911b2898b3c9fe0048e9485ad1629ed4fce330fd@git.kernel.org>
References: <20131111172925.GG26898@twins.programming.kicks-ass.net>
	 <tip-911b2898b3c9fe0048e9485ad1629ed4fce330fd@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-13 at 09:25 -0800, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  911b2898b3c9fe0048e9485ad1629ed4fce330fd
> Gitweb:     http://git.kernel.org/tip/911b2898b3c9fe0048e9485ad1629ed4fce330fd
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Mon, 11 Nov 2013 18:21:56 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 13 Nov 2013 13:33:54 +0100
> 
> sched: Optimize task_sched_runtime()
> 
> Large multi-threaded apps like to hit this using do_sys_times() and
> then queue up on the rq->lock.
> 
> Avoid when possible.
> 
> Larry reported ~20% performance increase his test case.
> 
> Reported-by: Larry Woodman <lwoodman@redhat.com>
> Suggested-by: Paul Turner <pjt@google.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Link: http://lkml.kernel.org/r/20131111172925.GG26898@twins.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

For what it's worth:

Tested-by: Davidlohr Bueso <davidlohr@hp.com>

