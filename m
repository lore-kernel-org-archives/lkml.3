Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaDAXE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:04:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59734 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaDAXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:04:24 -0400
Date: Tue, 1 Apr 2014 16:04:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.15
Message-ID: <20140401230419.GA22622@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140331081724.GA3193@gmail.com>
 <1396384291.23763.22.camel@x220>
 <20140401205219.GX4284@linux.vnet.ibm.com>
 <1396385946.23763.34.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396385946.23763.34.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040123-3532-0000-0000-000000B9D8E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 10:59:06PM +0200, Paul Bolle wrote:
> On Tue, 2014-04-01 at 13:52 -0700, Paul E. McKenney wrote:
> > I don't believe that this is particularly urgent, so unless someone
> > tells me otherwise, I will queue the fix for 3.16.
> 
> Few people share my OCD for Kconfig symbols. So most people will not
> think this is urgent. On the other hand, why wait three to four months
> when this can be cleaned up in a few weeks?

Because I need to decide whether the right fix is to add the
LOCK_TORTURE_RUNNABLE or to remove the RCU_TORTURE_RUNNABLE.  ;-)

My kneejerk reaction was the former, but I am leaning towards the latter.
Shrinks the code a bit, gets rid of a Kconfig parameter and only requires
changes in scripts for a few people using rcutorture...

							Thanx, Paul

