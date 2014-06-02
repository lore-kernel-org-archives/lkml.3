Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaFBUg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:36:58 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:47956 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752465AbaFBUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:36:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866
X-HE-Tag: stamp89_3c0a67069460f
X-Filterd-Recvd-Size: 2210
Message-ID: <1401741411.7323.36.camel@joe-AO725>
Subject: Re: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 13:36:51 -0700
In-Reply-To: <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140602133512.6d3f584314ecc423e63ffc8e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 13:35 -0700, Andrew Morton wrote:
> On Mon,  2 Jun 2014 10:00:20 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7321,6 +7321,7 @@ F:	kernel/rcu/torture.c
> >  
> >  RCUTORTURE TEST FRAMEWORK
> >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > +R:	Josh Triplett <josh@joshtriplett.org>
> >  L:	linux-kernel@vger.kernel.org
> >  S:	Supported
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> 
> I like the general principle - knowing who to poke regarding a kernel
> change is useful.
> 
> I don't care much whether it's "M:" or "R:", although "R:" carries more
> meaning and hence is probably better.
> 
> But why not "Cc:"?  That's meaningful too and is more copy-n-paste friendly.

For one, it'd take an extra bit of rework to get_maintainer.


