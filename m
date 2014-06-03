Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaFCACx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:02:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60279 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaFCACw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:02:52 -0400
Date: Mon, 2 Jun 2014 17:02:46 -0700
From: josh@joshtriplett.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
Message-ID: <20140603000246.GC14801@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
 <1401741411.7323.36.camel@joe-AO725>
 <538CE0E0.8020002@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CE0E0.8020002@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:38:56PM -0700, Randy Dunlap wrote:
> On 06/02/2014 01:36 PM, Joe Perches wrote:
> > On Mon, 2014-06-02 at 13:35 -0700, Andrew Morton wrote:
> >> On Mon,  2 Jun 2014 10:00:20 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >>> --- a/MAINTAINERS
> >>> +++ b/MAINTAINERS
> >>> @@ -7321,6 +7321,7 @@ F:	kernel/rcu/torture.c
> >>>  
> >>>  RCUTORTURE TEST FRAMEWORK
> >>>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >>> +R:	Josh Triplett <josh@joshtriplett.org>
> >>>  L:	linux-kernel@vger.kernel.org
> >>>  S:	Supported
> >>>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> >>
> >> I like the general principle - knowing who to poke regarding a kernel
> >> change is useful.
> >>
> >> I don't care much whether it's "M:" or "R:", although "R:" carries more
> >> meaning and hence is probably better.
> >>
> >> But why not "Cc:"?  That's meaningful too and is more copy-n-paste friendly.
> 
> Josh, what are you assuming that Andrew and I did not?

Not sure what you mean here.  Responding to the text you quoted: I have
no particular need to bikeshed the tag name, so if you prefer "Cc" and
can convince get_maintainer.pl to handle it, fine by me.

- Josh Triplett
