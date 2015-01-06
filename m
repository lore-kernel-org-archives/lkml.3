Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbbAFJk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:40:59 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43248 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbbAFJk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:40:57 -0500
Date: Tue, 6 Jan 2015 10:40:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106094039.GI29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:49:11AM +0100, Sedat Dilek wrote:
> This has been there since just before rc1. Is there a fix for this
> stalled in someones git tree maybe ?
> 
> [    7.952588] WARNING: CPU: 0 PID: 299 at kernel/sched/core.c:7303
> __might_sleep+0x8d/0xa0()
> [    7.952592] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff910a0f7a>] prepare_to_wait+0x2a/0x90
> [    7.952595] CPU: 0 PID: 299 Comm: systemd-readahe Not tainted 3.19.0-rc3+ #100

> [    7.952620]  [<ffffffff911a63e0>] fanotify_read+0xe0/0x5b0


http://marc.info/?l=linux-kernel&m=141874374029791
