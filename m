Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbbAMSnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:43:14 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60386 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbAMSnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:43:13 -0500
Date: Tue, 13 Jan 2015 10:43:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150113184301.GO9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com>
 <20150107014906.GA27996@mail.thefacebook.com>
 <20150107021926.GT5280@linux.vnet.ibm.com>
 <20150107165223.GA21555@linux.vnet.ibm.com>
 <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com>
 <alpine.DEB.2.11.1501131215380.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501131215380.5526@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011318-0005-0000-0000-000007FD6B11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:17:17PM +0100, Thomas Gleixner wrote:
> On Thu, 8 Jan 2015, Calvin Owens wrote:
> > On Wednesday 01/07 at 20:53 -0800, Paul E. McKenney wrote:
> > > > Should this go to stable as well? It is technically a regression, albeit
> > > > a rather long-standing one.
> > > 
> > > Your original patch could go into stable, but my updated version depends
> > > on functionality not present before 3.20.
> > 
> > Right. I'll wait until 3.20-rc1, and then I'll send the original to
> > stable with a reference to the commit.
> 
> We better do that in two steps:
> 
>    1) The original patch tagged for stable
>    2) Pauls version as a delta patch
> 
> Can one of you please provide such a series?

Carl, could you please send me the original with the proper -stable
reference?  I will then queue that one and rebase mine on top of it.

							Thanx, Paul

