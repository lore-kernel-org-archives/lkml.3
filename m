Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaHLQIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:08:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52683 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaHLQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:08:47 -0400
Date: Tue, 12 Aug 2014 09:08:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140812160840.GD4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140808183424.GB13483@grmbl.mre>
 <20140808214347.GH5821@linux.vnet.ibm.com>
 <20140808214648.GA19058@linux.vnet.ibm.com>
 <20140811071308.GA4184@grmbl.mre>
 <20140811162807.GW5821@linux.vnet.ibm.com>
 <20140811194126.GF4184@grmbl.mre>
 <20140811201102.GD5821@linux.vnet.ibm.com>
 <20140811201845.GG4184@grmbl.mre>
 <20140811203421.GE5821@linux.vnet.ibm.com>
 <20140812052726.GH4184@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812052726.GH4184@grmbl.mre>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081216-0928-0000-0000-0000040332A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 10:57:26AM +0530, Amit Shah wrote:
> On (Mon) 11 Aug 2014 [13:34:21], Paul E. McKenney wrote:
> > On Tue, Aug 12, 2014 at 01:48:45AM +0530, Amit Shah wrote:

[ . . . ]

> > > > In addition "sendkey alt-sysrq-t" at the "(qemu)" prompt dumps all tasks'
> > > > stacks, which would also likely be useful information.
> > > 
> > > Nah, this doesn't work -- the guest's totally locked up.  I need a way
> > > to continuously dump buffers till the lockup happens, I suppose.
> > 
> > That is a bit surprising.  Is it possible that the system is OOMing
> > quickly due to grace periods not proceeding?  If so, maybe giving the
> > VM more memory would help.
> 
> I bumped it up to 1G and then 2G, same result.

OK.  I am then back at making the system dump core.

							Thanx, Paul

