Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbbAMLRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:17:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:44067 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbAMLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:17:38 -0500
Date: Tue, 13 Jan 2015 12:17:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Calvin Owens <calvinowens@fb.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
In-Reply-To: <20150108214644.GC27996@mail.thefacebook.com>
Message-ID: <alpine.DEB.2.11.1501131215380.5526@nanos>
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com> <20150107014906.GA27996@mail.thefacebook.com> <20150107021926.GT5280@linux.vnet.ibm.com> <20150107165223.GA21555@linux.vnet.ibm.com> <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com> <20150108214644.GC27996@mail.thefacebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Calvin Owens wrote:
> On Wednesday 01/07 at 20:53 -0800, Paul E. McKenney wrote:
> > > Should this go to stable as well? It is technically a regression, albeit
> > > a rather long-standing one.
> > 
> > Your original patch could go into stable, but my updated version depends
> > on functionality not present before 3.20.
> 
> Right. I'll wait until 3.20-rc1, and then I'll send the original to
> stable with a reference to the commit.

We better do that in two steps:

   1) The original patch tagged for stable
   2) Pauls version as a delta patch

Can one of you please provide such a series?

Thanks,

	tglx
