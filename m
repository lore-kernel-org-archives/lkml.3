Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaFFUyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:54:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:35036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaFFUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:54:11 -0400
Date: Fri, 6 Jun 2014 22:54:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/locking/rtmutex-tester.c: kernel-doc warning
 fix
In-Reply-To: <20140606082323.GV6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1406062252210.25930@nanos>
References: <1401992965-11256-1-git-send-email-fabf@skynet.be> <20140606082323.GV6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Peter Zijlstra wrote:

> On Thu, Jun 05, 2014 at 08:29:25PM +0200, Fabian Frederick wrote:
> > attr was added by commit
> > 4a0b2b4dbe1335
> > ("sysdev: Pass the attribute to the low level sysdev show/store function")
> > 
> > and is unused here.
> 
> I think tglx has a patch killing this entire file somewhere..

Yes, it's on hold due to the more important issues in that area, but
that file will be gone soon.

Though I need to come up with something more intelligent as a
replacement to unit test all the corner cases we discovered in the
last weeks ....

Thanks,

	tglx
