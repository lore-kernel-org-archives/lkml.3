Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaHGBzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:55:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaHGBzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:55:53 -0400
Message-ID: <1407376502.12474.64.camel@fourier>
Subject: Re: [3.13.y.z extended stable] Patch "locking/mutex: Disable
 optimistic spinning on some architectures" has been added to staging queue
From: Kamal Mostafa <kamal@canonical.com>
To: Davidlohr Bueso <davidlohr@hp.com>, Andev <debiandev@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Vineet Gupta <vgupta@synopsys.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        John David Anglin <dave.anglin@bell.net>,
        James Hogan <james.hogan@imgtec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        kernel-team@lists.ubuntu.com
Date: Wed, 06 Aug 2014 18:55:02 -0700
In-Reply-To: <1407360614.3395.2.camel@buesod1.americas.hpqcorp.net>
References: <1407358496-23094-1-git-send-email-kamal@canonical.com>
	 <CAJUuVQ5OpNye8HAEw6x=owBB32pq-aLF7_Gqo493jDDHDahhRA@mail.gmail.com>
	 <1407360614.3395.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, 2014-08-06 at 17:25 -0400, Andev wrote:
> > On Wed, Aug 6, 2014 at 4:54 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> > > This is a note to let you know that I have just added a patch titled
> > >
> > >     locking/mutex: Disable optimistic spinning on some architectures
> > >
> > > to the linux-3.13.y-queue branch of the 3.13.y.z extended stable tree
> > > which can be found at:
> > >
> > >  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.13.y-queue
> > >
> > > This patch is scheduled to be released in version 3.13.11.6.
> > >
> > 
> > This patch is specifically for parisc, sparc32, tile32, metag-lock1,
> > arc-!llsc and hexagon none of which Ubuntu supports.
> > 
> > Why are you backporting this patch?

On Wed, 2014-08-06 at 14:30 -0700, Davidlohr Bueso wrote:
> Well 3.13.y.z isn't an Ubuntu kernel, its upstream, and those archs
> *are* supported.

Davidlohr's answer is correct: This is not an "Ubuntu kernel".

3.13.y.z is an "extended stable" kernel which follows the same rules as
the kernel.org official stable kernels.  It contains no Ubuntu-specific
patches, and supports the same arch's as mainline.

More details about this and the other Canonical-funded-and-hosted
"extended stable" kernel versions is available here:

> For more information about the 3.13.y.z tree, see
> https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal


