Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaGNNwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:52:54 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:41727
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686AbaGNNwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:52:47 -0400
Date: Mon, 14 Jul 2014 08:52:43 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
In-Reply-To: <20140712013941.GV16041@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1407140852140.24790@gentwo.org>
References: <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com> <20140708152358.GF6571@localhost.localdomain> <20140708154723.GN4603@linux.vnet.ibm.com> <20140708183846.GJ6571@localhost.localdomain> <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
 <20140711182541.GF26045@localhost.localdomain> <alpine.DEB.2.11.1407111403090.5070@gentwo.org> <20140711191113.GI26045@localhost.localdomain> <20140711203513.GA10652@linux.vnet.ibm.com> <20140711204503.GN26045@localhost.localdomain>
 <20140712013941.GV16041@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Paul E. McKenney wrote:

> >
> > I wonder if it's wouldn't be rather reasonable to affine housekeeping to all non-nohz-full CPUs
> > by default and then people who want finergrained housekeeping can affine manually kthreads from userspace.
> >
> > That implies to bind without PF_NO_SETAFFINIT but that's easy enough to do.
>
> Works for me!

Also here.

