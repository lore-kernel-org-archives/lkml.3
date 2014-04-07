Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaDGOeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:34:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40762 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaDGOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:34:00 -0400
Date: Mon, 7 Apr 2014 10:33:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock
 implementation
Message-ID: <20140407143300.GB2516@localhost.localdomain>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
 <1396445259-27670-2-git-send-email-Waiman.Long@hp.com>
 <20140404130012.GE10526@twins.programming.kicks-ass.net>
 <20140404165727.GQ19478@phenom.dumpdata.com>
 <20140407141258.GL10526@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407141258.GL10526@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 04:12:58PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 04, 2014 at 12:57:27PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, Apr 04, 2014 at 03:00:12PM +0200, Peter Zijlstra wrote:
> > > 
> > > So I'm just not ever going to pick up this patch; I spend a week trying
> > > to reverse engineer this; I posted a 7 patch series creating the
> > > equivalent, but in a gradual and readable fashion:
> > > 
> > >   http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
> > > 
> > > You keep on ignoring that; I'll keep on ignoring your patches.
> > > 
> > > I might at some point rewrite some of your pv stuff on top to get this
> > > moving again, but I'm not really motivated to work with you atm.
> > 
> > Uh? Did you CC also xen-devel@lists.xenproject.org on your patches Peter?
> > I hadn't had a chance to see or comment on them :-(
> 
> No of course not :-)
> 
> Also as noted elsewhere, I didn't actually do any PV muck yet. I spend
> the time trying to get my head around patch 1; all the while Waiman kept
> piling more and more on top.

Ah, I see. Looking forward to seeing your 'muck' code then :-)

Thanks!
