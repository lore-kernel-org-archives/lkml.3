Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBKQmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:42:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaBKQmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:42:37 -0500
Date: Tue, 11 Feb 2014 17:42:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5/9] rcu: Use MAX_NICE to replace hard coding of 19.
Message-ID: <20140211164230.GU27965@twins.programming.kicks-ass.net>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <20140211153732.GA2985@leaf>
 <20140211161313.GV4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211161313.GV4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 08:13:13AM -0800, Paul E. McKenney wrote:
> On Tue, Feb 11, 2014 at 07:37:32AM -0800, Josh Triplett wrote:
> > On Tue, Feb 11, 2014 at 03:34:49PM +0800, Dongsheng Yang wrote:
> > > Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> > > cc: Josh Triplett <josh@freedesktop.org>
> > > cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > cc: Peter Zijlstra <peterz@infradead.org>
> > > cc: Ingo Molnar <mingo@kernel.org>
> > 
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> I get complaints about MAX_NICE being undefined, and I don't see any
> definition of MAX_NICE in sched.h as of 3.14-rc2.  Am I looking in
> the wrong place, or is this symbol not yet quite in mainline?

It is not.. its a proposed thingy. I'm still trying to make up my mind
on it.
