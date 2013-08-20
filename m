Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3HTE2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:28:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57764 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3HTE2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:28:39 -0400
Date: Mon, 19 Aug 2013 21:28:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] v2 Documentation updates for 3.12
Message-ID: <20130820042832.GZ29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130820023717.GA29357@linux.vnet.ibm.com>
 <20130820032411.GC4416@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820032411.GC4416@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082004-1542-0000-0000-000000A7F9B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 08:24:11PM -0700, Josh Triplett wrote:
> On Mon, Aug 19, 2013 at 07:37:17PM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This series provides a few documentation updates:
> > 
> > 1.	Update rcu_barrier() documentation to note that it no longer is
> > 	guaranteed to wait for a full grace period.  This guarantee was
> > 	a victim of energy efficiency.
> > 
> > 2.	Update RTFP documentation.
> > 
> > 3.	Fix a control-dependency example in the memory-barriers
> > 	documentation.
> > 
> > Changes from v1 (https://lkml.org/lkml/2013/8/17/94):
> > 
> > o	Apply Josh Triplett review comments.
> 
> Consider changing the patch tag for new versions, to "PATCH v2" or
> similar; that way, all of the patches have a clearly distinct subject
> for the new version.
> 
> git format-patch will do this for you; just pass "-v 2".

Good point, my email client got them confused as well.  My version of git
format-patch does not know about "-v 2", but --subject-prefix="PATCH v2"
does fine.  I am using git version 1.8.1.5, for whatever it is worth.

							Thanx, Paul

