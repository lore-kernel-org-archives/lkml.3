Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaDAUwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:52:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50918 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaDAUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:52:24 -0400
Date: Tue, 1 Apr 2014 13:52:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.15
Message-ID: <20140401205219.GX4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140331081724.GA3193@gmail.com>
 <1396384291.23763.22.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396384291.23763.22.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040120-6688-0000-0000-000000C7C67A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 10:31:31PM +0200, Paul Bolle wrote:
> > Paul E. McKenney (70):
> >      [...]
> >       locktorture: Add a lock-torture kernel module
> 
> This commit added a check for CONFIG_LOCK_TORTURE_TEST_RUNNABLE. But I
> can't find a Kconfig symbol LOCK_TORTURE_TEST_RUNNABLE nor a
> preprocessor define for CONFIG_LOCK_TORTURE_TEST_RUNNABLE. (I only
> checked master of Linus's tree and linux-next.)
> 
> Is this check for CONFIG_LOCK_TORTURE_TEST_RUNNABLE needed?

My bad.  My current tests use the boot parameter rather than relying on
the Kconfig parameter, so I missed this bug.  I will of course fix it.
I don't believe that this is particularly urgent, so unless someone
tells me otherwise, I will queue the fix for 3.16.

							Thanx, Paul

