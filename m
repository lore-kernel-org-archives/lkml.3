Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaBKRmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:42:49 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42791 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBKRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:42:47 -0500
Date: Tue, 11 Feb 2014 09:42:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@freedesktop.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5/9] rcu: Use MAX_NICE to replace hard coding of 19.
Message-ID: <20140211174238.GW4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <20140211153732.GA2985@leaf>
 <20140211161313.GV4250@linux.vnet.ibm.com>
 <20140211164230.GU27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211164230.GU27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021117-1344-0000-0000-000005A11136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:42:30PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 08:13:13AM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 11, 2014 at 07:37:32AM -0800, Josh Triplett wrote:
> > > On Tue, Feb 11, 2014 at 03:34:49PM +0800, Dongsheng Yang wrote:
> > > > Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> > > > cc: Josh Triplett <josh@freedesktop.org>
> > > > cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > cc: Peter Zijlstra <peterz@infradead.org>
> > > > cc: Ingo Molnar <mingo@kernel.org>
> > > 
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > I get complaints about MAX_NICE being undefined, and I don't see any
> > definition of MAX_NICE in sched.h as of 3.14-rc2.  Am I looking in
> > the wrong place, or is this symbol not yet quite in mainline?
> 
> It is not.. its a proposed thingy. I'm still trying to make up my mind
> on it.

OK, will hold off then.

							Thanx, Paul

