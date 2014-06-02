Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaFBUlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:41:44 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55109 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaFBUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:41:37 -0400
Date: Tue, 3 Jun 2014 02:11:17 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>, josh@joshtriplett.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602204117.GA24117@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <1401734669.7323.20.camel@joe-AO725>
 <20140602145020.400d4e0c@gandalf.local.home>
 <20140602185504.GA13569@cloud>
 <1401735917.7323.23.camel@joe-AO725>
 <20140602192631.GA22231@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602192631.GA22231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060220-9332-0000-0000-000000F8CB28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:26:31PM -0700, Paul E. McKenney wrote:
> On Mon, Jun 02, 2014 at 12:05:17PM -0700, Joe Perches wrote:
> > On Mon, 2014-06-02 at 11:55 -0700, josh@joshtriplett.org wrote:
> > > this should go along with a change to
> > > get_maintainer.pl to add those folks to the CC list.
> > 
> > Something like this:
> 
> To test this, I added a comment to kernel/rcu/srcu.c, then ran
> scripts/get_maintainer.pl on the resulting diffs.  Without the
> below change to scripts/get_maintainer.pl, I get the following:
> 
> Lai Jiangshan <laijs@cn.fujitsu.com> (supporter:SLEEPABLE READ-CO...)
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (supporter:SLEEPABLE READ-CO...)
> Dipankar Sarma <dipankar@in.ibm.com> (supporter:READ-COPY UPDATE...)
> linux-kernel@vger.kernel.org (open list:SLEEPABLE READ-CO...)
> 
> With the below change, it includes Josh, as expected based on the "R:"
> entry I had previously added to MAINTAINERS in my local tree:
> 
> Lai Jiangshan <laijs@cn.fujitsu.com> (supporter:SLEEPABLE READ-CO...)
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (supporter:SLEEPABLE READ-CO...)
> Josh Triplett <josh@joshtriplett.org> (reviewer)
> Dipankar Sarma <dipankar@in.ibm.com> (supporter:READ-COPY UPDATE...)
> linux-kernel@vger.kernel.org (open list:SLEEPABLE READ-CO...)

Paul,

Sorry, I hadn't noticed it earlier. I can be dropped. Not that I
am not interested, just that I am working on too many itsy bitsy
things many outside the kernel and also herding cats, to find
time :-)

Thanks
Dipankar

