Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaLSX6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:58:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:36278 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLSX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:58:31 -0500
Date: Sat, 20 Dec 2014 00:57:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Khalid Aziz <khalid.aziz@oracle.com>
cc: Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, riel@redhat.com, akpm@linux-foundation.org,
        rientjes@google.com, ak@linux.intel.com, mgorman@suse.de,
        raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com,
        avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com,
        athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com,
        daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
In-Reply-To: <54949BF0.8030403@oracle.com>
Message-ID: <alpine.DEB.2.11.1412200041220.17382@nanos>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos> <54936562.5070502@oracle.com> <alpine.DEB.2.11.1412190045590.17382@nanos>
 <54949BF0.8030403@oracle.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Khalid Aziz wrote:
> The queuing problem caused by a task taking a contended lock just before its
> current timeslice is up which userspace app wouldn't know about, is a real
> problem nevertheless.

We know that already.

> My patch attempts to avoid the contention in the first
> place. futex with adaptive spinning is a post-contention solution that tries
> to minimize the cost of contention but does nothing to avoid the contention.

I never said that adaptive spinning can solve that problem. 

If you would have carefuly read what I wrote, you might have noticed,
that I said: 

     a proper futex like spin mechanism

Can you spot the subtle difference between that phrase and 'futex with
adaptive spinning'?

> Solving this problem using futex can help only if the userspace lock uses
> futex.

A really fundamentally new and earth shattering insight.

If you would spend your time to actually digest what maintainers are
telling you, we might make progress on that matter.

But you prefer to spend your time by repeating yourself and providing
completely useless information.

What you are missing completely here is that neither me nor other
maintainers involved care about how you spend your time. But we very
much care about the time WE waste with your behaviour.

Thanks,

	tglx
