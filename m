Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3HRC5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:57:52 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49645 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3HRC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:57:51 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 19:57:40 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/5] rcu: Sort rcutorture module parameters
Message-ID: <20130818025740.GD28923@leaf>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376792717-3755-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376792717-3755-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 07:25:15PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> There are getting to be too many module parameters to permit the current
> semi-random order, so this patch orders them.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

As long as you're reordering them anyway, how about grouping each of the
variables together with the corresponding module parameter macros, and
then dropping the comments that duplicate the module parameter
documentation?

With that change:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
