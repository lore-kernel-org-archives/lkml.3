Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJSMbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 08:31:23 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44683 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaJSMbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 08:31:21 -0400
Date: Sun, 19 Oct 2014 15:31:19 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/sched/core.c:2702!
In-Reply-To: <alpine.LRH.2.11.1410171401110.25429@adalberg.ut.ee>
Message-ID: <alpine.LRH.2.11.1410191515150.32417@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410171401110.25429@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am seeing this BUG on 3 different sparc64 machines with yesterdays 
> git. sparc64-specific known problems were just fixed before, 
> 3.17.0-07551-g052db7e + slab alignment fix patch + sparc64 SIGBUS fix 
> patch is working stable for me, whereas 3.17.0-09670-g0429fbc + SIGBUS 
> patch fails on 3 machines (all I tried). Will try bisecting later if I 
> get time.

Dave Miller identified it as a sparc64-specific problem with 
CONFIG_SCHED_STACK_END_CHECK in another thread and his fix is working 
for me.

-- 
Meelis Roos (mroos@linux.ee)
