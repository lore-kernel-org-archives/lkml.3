Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaB1QKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:10:44 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42750 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaB1QKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:10:43 -0500
Date: Fri, 28 Feb 2014 08:10:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, peterz@infradead.org, oleg@redhat.com,
        rostedt@goodmis.org
Subject: Re: [GIT PULL timers] Timer-wheel bandaids^Wcommits for 3.15
Message-ID: <20140228161037.GB11910@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140228012704.GA20805@linux.vnet.ibm.com>
 <1393563998.6018.19.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393563998.6018.19.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022816-1344-0000-0000-00000625CED6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 06:06:38AM +0100, Mike Galbraith wrote:
> On Thu, 2014-02-27 at 17:27 -0800, Paul E. McKenney wrote: 
> > Hello, Thomas and Ingo,
> > 
> > This pull request contains latency bandaids^Woptimizations to the
> > timer-wheel code that are useful in conjunction with NO_HZ_FULL Kconfig
> > option.  These optimizations reduce the jiffy-by-jiffy looping in cases
> > where there is either zero or one timers in the timer wheel, which is
> > a common case for NO_HZ_FULL "worker" CPUs that run almost entirely
> > in usermode for a single task.
> 
> FWIW, these have seen quite a bit of runtime on various boxen, both in
> day to day and piddle about -rt kernels, with zero attention grabbers.

Thank you very much for your testing efforts, Mike!

							Thanx, Paul

