Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaFBSu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:50:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:31356 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751286AbaFBSuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:50:24 -0400
Date: Mon, 2 Jun 2014 14:50:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602145020.400d4e0c@gandalf.local.home>
In-Reply-To: <1401734669.7323.20.camel@joe-AO725>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1401729778.5770.20.camel@joe-AO725>
	<20140602174837.GA13257@cloud>
	<1401731968.7323.4.camel@joe-AO725>
	<20140602181658.GX22231@linux.vnet.ibm.com>
	<1401734669.7323.20.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014 11:44:29 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-06-02 at 11:16 -0700, Paul E. McKenney wrote:
> > But there have been people who have found serious issues in RCU patches
> > who I would not trust as full maintainers.  The ability to find defects
> > is valuable in and of itself, and should be recognized as such, even
> > when not accompanied by the rest of the maintainership package.
> 
> Maybe, but odd-lot reviewers are most likely going to find
> these same defects regardless of any "R" designation in
> MAINTAINERS.
> 

Actually, I'm thinking the R: tag is a good idea and we should have
people ask to be added to MAINTAINERS if they want to review certain
subsystems. Grant you, it should be people that the maintainers trust.
I can think of several people I would like to be added as R: in tracing.

The point is, when patches go out, it is easy to see who the Cc list
should be. And perhaps this will get patches reviewed more. Maybe
maintainers of other subsystems should ask to have the R: tag added for
something they don't maintain but want to help out in.

I may add myself to the x86, scheduler, time keeping and perhaps even
RCU, as I like to read those patches. I'm not at the level of
maintaining those subsystems, but I feel comfortable enough to review
any changes there.

-- Steve
