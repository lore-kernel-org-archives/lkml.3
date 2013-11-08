Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3KHOpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:45:50 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41984 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab3KHOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:45:49 -0500
Date: Fri, 8 Nov 2013 06:45:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
Message-ID: <20131108144534.GE18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383228427.5272.36.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
 <1383794799.5441.16.camel@marge.simpson.net>
 <1383798668.5441.25.camel@marge.simpson.net>
 <20131108032343.GA18245@linux.vnet.ibm.com>
 <1383895880.4964.91.camel@marge.simpson.net>
 <20131108123713.GC18245@linux.vnet.ibm.com>
 <1383917188.4964.94.camel@marge.simpson.net>
 <20131108140331.GD18245@linux.vnet.ibm.com>
 <20131108142934.GA11112@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108142934.GA11112@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110814-0928-0000-0000-00000336ABDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 03:29:38PM +0100, Frederic Weisbecker wrote:
> On Fri, Nov 08, 2013 at 06:03:31AM -0800, Paul E. McKenney wrote:
> > On Fri, Nov 08, 2013 at 02:26:28PM +0100, Mike Galbraith wrote:
> > > On Fri, 2013-11-08 at 04:37 -0800, Paul E. McKenney wrote: 
> > > > On Fri, Nov 08, 2013 at 08:31:20AM +0100, Mike Galbraith wrote:
> > > > > On Thu, 2013-11-07 at 19:23 -0800, Paul E. McKenney wrote:
> > > > > 
> > > > > > An untested patch that gets rid of the RCU_SOFTIRQs in this case is below.
> > > > > 
> > > > > Yup, toasted.
> > > > 
> > > > You lost me on this one.  If my patch broke your system, any chance of
> > > > any diagnostic information?
> > > 
> > > No no, the RCU_SOFTIRQs are toast, history, gone.
> > 
> > Ah, I do like that outcome much better!  ;-)  The scheduling-clock
> > interrupts are gone (or at least reduced) as well?
> > 
> > And does this mean that I can have your Tested-by?
> 
> What's wrong with Toasted-by: ?  ;)

Does this mean that I can have your Toasted by?  ;-)

							Thanx, Paul

