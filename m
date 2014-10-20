Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaJTPmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:42:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:17479 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751053AbaJTPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:42:52 -0400
Date: Mon, 20 Oct 2014 11:42:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill V Tkhai <tkhai@yandex.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: do not try to push tasks if pinned task
 switches to dl
Message-ID: <20141020114236.436f091d@gandalf.local.home>
In-Reply-To: <5437B462.4050102@gmail.com>
References: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com>
	<20141010101016.GJ10832@worktop.programming.kicks-ass.net>
	<5437B462.4050102@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014 18:26:42 +0800
Wanpeng Li <kernellwp@gmail.com> wrote:


> > ERROR: Please use 12 or more chars for the git commit ID like: 'commit 10447917551e ("sched/rt: Do not try to push tasks if pinned task switches to RT")'
> > #12:
> > which introduced by commit 104479 (sched/rt: Do not try to push tasks
> 
> I also got this warning before send out the patch, however, I check 6 
> chars is enough for this commit. Anyway, I will send a newer version later.

6 chars may be enough today, but there's no guarantee that it will be
enough tomorrow, when someone reads this changelog years from now.

-- Steve
