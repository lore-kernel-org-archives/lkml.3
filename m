Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3KHOxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:53:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab3KHOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:53:53 -0500
Message-ID: <1383922427.4964.123.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Fri, 08 Nov 2013 15:53:47 +0100
In-Reply-To: <20131108142934.GA11112@localhost.localdomain>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:GO8w0ulLrP2+sMwaXBCSK6ZwAsMyt8ygN0wY+/JMRXw
 pGohJsE0M196AIW0gppyrXBmk6M5Fo1hF1rTg+qJLYS3tEXHV+
 6yyq43SUow167eA98UaP+JK5683mEV6H3r6ggWS31q2rgDnDJ2
 fffvenMmteyDL/ghPrIauJl1tXNtLxNiBFm0AwSzGrpwWigF0l
 ZTcYOGx/2RSgavpvqdoSHnwAiNVrVnsle2w9u5ECvTPj3SjBMA
 lA7dv8AlXw91kdVBUnfJE9Xlnw9RbP5++PcBDqIAgw23LpI0gx
 L7f2sINSz+g4IGLVrHZGPjEhamYZOoZw2qQ08pnSSr546VSXFH
 1jEjGeeFXNvf2puZvwQYDKyFfE/QLT5Am16K5Kx5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 15:29 +0100, Frederic Weisbecker wrote: 
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

It sprang to mind, but I resisted :)

