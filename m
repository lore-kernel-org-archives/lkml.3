Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763Ab3HSEEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:04:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45406 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3HSED6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:03:58 -0400
Date: Sun, 18 Aug 2013 21:03:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/5] rcu: Sort rcutorture module parameters
Message-ID: <20130819040350.GE29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376792717-3755-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376792717-3755-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818025740.GD28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818025740.GD28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081904-5518-0000-0000-0000114D693E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 07:57:40PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 07:25:15PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > There are getting to be too many module parameters to permit the current
> > semi-random order, so this patch orders them.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> As long as you're reordering them anyway, how about grouping each of the
> variables together with the corresponding module parameter macros, and
> then dropping the comments that duplicate the module parameter
> documentation?
> 
> With that change:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Good point, done!

							Thanx, Paul

