Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaJJKKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:10:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:45537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJJKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:10:17 -0400
Date: Fri, 10 Oct 2014 12:10:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill V Tkhai <tkhai@yandex.ru>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: do not try to push tasks if pinned task
 switches to dl
Message-ID: <20141010101016.GJ10832@worktop.programming.kicks-ass.net>
References: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:43:17AM +0800, Wanpeng Li wrote:
> As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
> | If rq has already had 2 or more pushable tasks and we try to add a 
> | pinned task then call of push_rt_task will just waste a time.
> 
> Just switched pinned task is not able to be pushed. If the rq had had
> several dl tasks before they have already been considered as candidates
> to be pushed (or pulled). This patch does the same behavior as rt class 
> which introduced by commit 104479 (sched/rt: Do not try to push tasks 
> if pinned task switches to RT). 

Checkpatch rightly complains:

ERROR: Please use 12 or more chars for the git commit ID like: 'commit 10447917551e ("sched/rt: Do not try to push tasks if pinned task switches to RT")'
#12: 
which introduced by commit 104479 (sched/rt: Do not try to push tasks


