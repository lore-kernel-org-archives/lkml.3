Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3KHOWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:22:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3KHOWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:22:05 -0500
Message-ID: <1383920517.4964.104.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Fri, 08 Nov 2013 15:21:57 +0100
In-Reply-To: <20131108140331.GD18245@linux.vnet.ibm.com>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <20131108032343.GA18245@linux.vnet.ibm.com>
	 <1383895880.4964.91.camel@marge.simpson.net>
	 <20131108123713.GC18245@linux.vnet.ibm.com>
	 <1383917188.4964.94.camel@marge.simpson.net>
	 <20131108140331.GD18245@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:au5MS92aLCodOXTUVi3KCQ2uFu4UQrNh5AdbTBdVoRF
 TnDujglCu1rRTOwEOe6PXJiBnnnsk+soo0bKGvvDPOht/04x7E
 8t/ERKy8kH+jCVuBqJdJQTUIUE7zO3tl3UHoIz4Dc4p3Lha7yt
 KPt8UiNJSCej5hCJWFM4mZrq1/O1kiMVV4BABG/OoH/M/juLqJ
 erzX9dpqD2zf1I9E37d+YI5llKA5kikCwcgDapKVITfva2v4hX
 HNPMEuQy7f9ZGO2hIOhQpWtdti2uQflQShHliJg+1pGT41FHU6
 s0L68eTF/A9GHBiyYTdH+YyWSNZqsaA8MNW8Wy4mT1iwZBPFEr
 N2Gwa107UduCUK7WmWlyVjNmZY4sCUgj+0T8Glhol
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 06:03 -0800, Paul E. McKenney wrote: 
> On Fri, Nov 08, 2013 at 02:26:28PM +0100, Mike Galbraith wrote:
> > On Fri, 2013-11-08 at 04:37 -0800, Paul E. McKenney wrote: 
> > > On Fri, Nov 08, 2013 at 08:31:20AM +0100, Mike Galbraith wrote:
> > > > On Thu, 2013-11-07 at 19:23 -0800, Paul E. McKenney wrote:
> > > > 
> > > > > An untested patch that gets rid of the RCU_SOFTIRQs in this case is below.
> > > > 
> > > > Yup, toasted.
> > > 
> > > You lost me on this one.  If my patch broke your system, any chance of
> > > any diagnostic information?
> > 
> > No no, the RCU_SOFTIRQs are toast, history, gone.
> 
> Ah, I do like that outcome much better!  ;-)  The scheduling-clock
> interrupts are gone (or at least reduced) as well?

No, tick shutdown needs encouragement to succeed, but there were no
RCU_SOFTIRQs on rcu_nocbs= CPUs.

> And does this mean that I can have your Tested-by?

Tested-by: Mike Galbraith <bitbucket@online.de>

