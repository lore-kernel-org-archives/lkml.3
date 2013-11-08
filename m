Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3KHN0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:26:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3KHN0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:26:34 -0500
Message-ID: <1383917188.4964.94.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Fri, 08 Nov 2013 14:26:28 +0100
In-Reply-To: <20131108123713.GC18245@linux.vnet.ibm.com>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <20131108032343.GA18245@linux.vnet.ibm.com>
	 <1383895880.4964.91.camel@marge.simpson.net>
	 <20131108123713.GC18245@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:VfpykriFRihAG/ncYw3mtDduf2vU3VcwTJ77Or7WZGg
 kQlZjWMuNb4AHEw+sHQPsrjKKAQDHi0YTrd3cney1NS0cKELlj
 RsyBEJIGWa4pjA7DXNn9wKeRG/U4OLZ4qqwVfNVNyuwLlaoVmy
 3wBIgUfSXIoASR/367MDJ11m2me234A3ZJRK8hygjhFpXIz68g
 axquAu0Nc871DE20GXEbdQrjLwsxs+rLzepE6se9YIDny3DkAl
 M7TvcM/bYCcV/IFccfGH+289pA9tL4Aa8GnyYySLHOBfu0bvwk
 nd4iwngXytWh9SG9B5xHZvZH63+n8xmrWKkVP8Go/6umoQo8dk
 xE/S/7Vq2Pj+1nNPOPD5d8/sWyLYfcxU9XOyG+i9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 04:37 -0800, Paul E. McKenney wrote: 
> On Fri, Nov 08, 2013 at 08:31:20AM +0100, Mike Galbraith wrote:
> > On Thu, 2013-11-07 at 19:23 -0800, Paul E. McKenney wrote:
> > 
> > > An untested patch that gets rid of the RCU_SOFTIRQs in this case is below.
> > 
> > Yup, toasted.
> 
> You lost me on this one.  If my patch broke your system, any chance of
> any diagnostic information?

No no, the RCU_SOFTIRQs are toast, history, gone.

-Mike

