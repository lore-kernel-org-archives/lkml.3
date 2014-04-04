Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaDDRxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:53:44 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53937 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaDDRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:53:41 -0400
Date: Fri, 4 Apr 2014 19:53:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock
 implementation
Message-ID: <20140404175335.GA25949@gmail.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
 <1396445259-27670-2-git-send-email-Waiman.Long@hp.com>
 <20140404130012.GE10526@twins.programming.kicks-ass.net>
 <533EC8BD.8080601@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EC8BD.8080601@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 04/04/2014 09:00 AM, Peter Zijlstra wrote:
> >
> > So I'm just not ever going to pick up this patch; I spend a week 
> > trying to reverse engineer this; I posted a 7 patch series 
> > creating the equivalent, but in a gradual and readable fashion:
> >
> >   http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
> >
> > You keep on ignoring that; I'll keep on ignoring your patches.
> >
> > I might at some point rewrite some of your pv stuff on top to get 
> > this moving again, but I'm not really motivated to work with you 
> > atm.
> 
> Peter, I am sorry that I have focused recently on making the 
> qspinlock patch works with virtualization and it is easier for me to 
> based off on my patch initially. Now the PV part is almost done, I 
> will apply them on top of your patch. Hopefully, I will get a new 
> patch out sometime next week.

Note that it's not "a patch" that PeterZ posted, but a series of 7 
finegrained patches, each properly documented and commented. Please 
preserve that work, build on top of it, and don't just ignore it!

Thanks,

	Ingo
