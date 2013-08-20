Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3HTFFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:05:44 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51406 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3HTFFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:05:43 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 19 Aug 2013 22:05:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] v2 Documentation updates for 3.12
Message-ID: <20130820050527.GA7333@leaf>
References: <20130820023717.GA29357@linux.vnet.ibm.com>
 <20130820032411.GC4416@leaf>
 <20130820042832.GZ29406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820042832.GZ29406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:28:32PM -0700, Paul E. McKenney wrote:
> On Mon, Aug 19, 2013 at 08:24:11PM -0700, Josh Triplett wrote:
> > On Mon, Aug 19, 2013 at 07:37:17PM -0700, Paul E. McKenney wrote:
> > > Hello!
> > > 
> > > This series provides a few documentation updates:
> > > 
> > > 1.	Update rcu_barrier() documentation to note that it no longer is
> > > 	guaranteed to wait for a full grace period.  This guarantee was
> > > 	a victim of energy efficiency.
> > > 
> > > 2.	Update RTFP documentation.
> > > 
> > > 3.	Fix a control-dependency example in the memory-barriers
> > > 	documentation.
> > > 
> > > Changes from v1 (https://lkml.org/lkml/2013/8/17/94):
> > > 
> > > o	Apply Josh Triplett review comments.
> > 
> > Consider changing the patch tag for new versions, to "PATCH v2" or
> > similar; that way, all of the patches have a clearly distinct subject
> > for the new version.
> > 
> > git format-patch will do this for you; just pass "-v 2".
> 
> Good point, my email client got them confused as well.  My version of git
> format-patch does not know about "-v 2", but --subject-prefix="PATCH v2"
> does fine.  I am using git version 1.8.1.5, for whatever it is worth.

I have 1.8.4.rc3, which has -v.

- Josh Triplett
