Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3LESSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:18:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50748 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3LESSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:18:41 -0500
Date: Thu, 5 Dec 2013 10:18:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, mingo@kernel.org, henrik@austad.us,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131205181834.GV15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131205105928.GA27382@austad.us>
 <20131205122851.GB20562@gmail.com>
 <20131205085146.0370ea2a@gandalf.local.home>
 <20131205.130524.997340443429884333.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205.130524.997340443429884333.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120518-0928-0000-0000-0000041CE789
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 01:05:24PM -0500, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Thu, 5 Dec 2013 08:51:46 -0500
> 
> > I wish vger wouldn't do that. I wonder how much spam is really flagged
> > by this one characteristic alone. That is, spam that would have made it
> > otherwise, but because of the Cc list, it was rejected.
> 
> 10 to 20 spam posts per day are prevented by this rule.
> 
> And frankly it's totally rediculous to have such a huge CC: list
> in the first place, even if the vger spam filter didn't exist.
> 
> If you CC: something to netdev, it's going to reach me, you don't need
> to CC: me.  If just makes for a dup that I have to delete in my inbox,
> so you're actually making more work for me in the end.
> 
> That's just one example.

Hello, David,

The situation that leads me to use a large CC list is when I am doing
something that affects all architectures.  I could imagine keeping a
smallish CC list, then forwarding or bouncing the email to the remaining
maintainers  Would that work reasonably, or is there some better approach?

							Thanx, Paul

