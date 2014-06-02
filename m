Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaFBTuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:50:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33261 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaFBTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:50:23 -0400
Date: Mon, 2 Jun 2014 12:50:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602195017.GC22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <20140602185635.GB13569@cloud>
 <20140602190821.GZ22231@linux.vnet.ibm.com>
 <20140602191155.GB13648@cloud>
 <20140602192729.GB22231@linux.vnet.ibm.com>
 <1401737782.7323.31.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401737782.7323.31.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060219-7164-0000-0000-0000022B890E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:36:22PM -0700, Joe Perches wrote:
> On Mon, 2014-06-02 at 12:27 -0700, Paul E. McKenney wrote:
> > On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
> > > 
> > > I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
> > > as reviewers as well, with their consent.
> > 
> > Mathieu, Oleg, Lai, any objections?
> 
> I suggest not going overboard with R entries.
> If there are more than 1 or 2, create a mailing list.

Having a limit of two seems reasonable.  First to the post, then.
Or maybe last to object?  ;-)

> And more entries will just make the churn and name-decay
> in MAINTAINERS that much more prevalent.
> 
> None of those people have any significant
> quantities of commit entries for rcu
> 
> (with the get_maintainer patch posted)
> 
> $ ./scripts/get_maintainer.pl -f kernel/rcu/ --git --git-min-percent=3
> Dipankar Sarma <dipankar@in.ibm.com> (supporter:READ-COPY UPDATE...)
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (supporter:READ-COPY UPDATE...,commit_signer:82/85=96%,authored:58/85=68%)
> Josh Triplett <josh@joshtriplett.org> (reviewer,commit_signer:56/85=66%)
> Ingo Molnar <mingo@kernel.org> (commit_signer:5/85=6%)
> Peter Zijlstra <peterz@infradead.org> (commit_signer:5/85=6%)
> Thomas Gleixner <tglx@linutronix.de> (commit_signer:3/85=4%)
> Andreea-Cristina Bernat <bernat.ada@gmail.com> (authored:3/85=4%)
> linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)

Good to know, but then again, I sometimes review patches in areas where
I have no commits.

							Thanx, Paul

