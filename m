Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaEGX74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:59:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49932 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaEGX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:59:55 -0400
Date: Wed, 7 May 2014 16:59:48 -0700
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
Message-ID: <20140507235948.GU8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212609.GF27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507212609.GF27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050723-0928-0000-0000-000001C754F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:26:09PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:24:59PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit makes the torture scripts a bit more RCU-independent.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Bug below; with that fixed,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> [...]
> > @@ -378,7 +378,8 @@ then
> >  	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
> >  	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
> >  	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
> > -	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
> > +	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
> > +		export TORTURE_QEMU_INTERACTIVE"
> 
> Don't break this line in the middle of your quoted string.

Good point, will fix!

							Thanx, Paul

