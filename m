Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaDDRzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:55:00 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43788 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaDDRy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:54:58 -0400
Date: Fri, 4 Apr 2014 19:54:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20140404175452.GB25949@gmail.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
 <1396445259-27670-2-git-send-email-Waiman.Long@hp.com>
 <20140404130012.GE10526@twins.programming.kicks-ass.net>
 <20140404165727.GQ19478@phenom.dumpdata.com>
 <533EE700.4080408@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EE700.4080408@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 04/04/2014 12:57 PM, Konrad Rzeszutek Wilk wrote:
> >On Fri, Apr 04, 2014 at 03:00:12PM +0200, Peter Zijlstra wrote:
> >>So I'm just not ever going to pick up this patch; I spend a week trying
> >>to reverse engineer this; I posted a 7 patch series creating the
> >>equivalent, but in a gradual and readable fashion:
> >>
> >>   http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
> >>
> >>You keep on ignoring that; I'll keep on ignoring your patches.
> >>
> >>I might at some point rewrite some of your pv stuff on top to get this
> >>moving again, but I'm not really motivated to work with you atm.
> >Uh? Did you CC also xen-devel@lists.xenproject.org on your patches Peter?
> >I hadn't had a chance to see or comment on them :-(
> >
> 
> Peter's patch is a rewrite of my patches 1-4, there is no PV or 
> unfair lock support in there.

It is a fine grained split-up, which does one thing at a time, so it 
all becomes reviewable and mergable (and the claimed effects become 
testable!). Please use that as a base.

Thanks,

	Ingo
