Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaEGX6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:58:01 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49080 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaEGX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:58:00 -0400
Date: Wed, 7 May 2014 16:57:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/45] torture: Rename RCU_QEMU_INTERACTIVE
 to TORTURE_QEMU_INTERACTIVE
Message-ID: <20140507235753.GS8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212708.GG27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507212708.GG27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050723-7164-0000-0000-0000019787FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:27:08PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:24:59PM -0700, Paul E. McKenney wrote:
> > -		if test -n "$RCU_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
> > +		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
> >  		then
> >  			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
> >  			echo -netdev bridge,br=br0,id=net0
> > -		elif test -n "$RCU_QEMU_INTERACTIVE"
> > +		elif test -n "$TORTURE_QEMU_INTERACTIVE"
> >  		then
> >  			echo -net nic -net user
> 
> Not related to this patch, but: qemu defaults to -net nic -net user, so
> you don't need to specify it.

Good point, I wasn't aware of that.  Paranoia will probably cause me
to leave it explicitly specified, though.

And yes, I freely admit that my paranoia is not evenly distributed.  ;-)

							Thanx, Paul

