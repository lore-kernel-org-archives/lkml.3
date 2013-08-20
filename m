Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3HTDY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:24:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48332 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3HTDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:24:25 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 19 Aug 2013 20:24:11 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] v2 Documentation updates for 3.12
Message-ID: <20130820032411.GC4416@leaf>
References: <20130820023717.GA29357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820023717.GA29357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 07:37:17PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a few documentation updates:
> 
> 1.	Update rcu_barrier() documentation to note that it no longer is
> 	guaranteed to wait for a full grace period.  This guarantee was
> 	a victim of energy efficiency.
> 
> 2.	Update RTFP documentation.
> 
> 3.	Fix a control-dependency example in the memory-barriers
> 	documentation.
> 
> Changes from v1 (https://lkml.org/lkml/2013/8/17/94):
> 
> o	Apply Josh Triplett review comments.

Consider changing the patch tag for new versions, to "PATCH v2" or
similar; that way, all of the patches have a clearly distinct subject
for the new version.

git format-patch will do this for you; just pass "-v 2".

- Josh Triplett
