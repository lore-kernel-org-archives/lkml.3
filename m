Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaHFVaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:30:24 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:57496 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaHFVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:30:23 -0400
Message-ID: <1407360614.3395.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [3.13.y.z extended stable] Patch "locking/mutex: Disable
 optimistic spinning on some architectures" has been added to staging queue
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andev <debiandev@gmail.com>
Cc: Kamal Mostafa <kamal@canonical.com>, Peter Zijlstra <peterz@infradead.org>,
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
Date: Wed, 06 Aug 2014 14:30:14 -0700
In-Reply-To: <CAJUuVQ5OpNye8HAEw6x=owBB32pq-aLF7_Gqo493jDDHDahhRA@mail.gmail.com>
References: <1407358496-23094-1-git-send-email-kamal@canonical.com>
	 <CAJUuVQ5OpNye8HAEw6x=owBB32pq-aLF7_Gqo493jDDHDahhRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 17:25 -0400, Andev wrote:
> On Wed, Aug 6, 2014 at 4:54 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> > This is a note to let you know that I have just added a patch titled
> >
> >     locking/mutex: Disable optimistic spinning on some architectures
> >
> > to the linux-3.13.y-queue branch of the 3.13.y.z extended stable tree
> > which can be found at:
> >
> >  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.13.y-queue
> >
> > This patch is scheduled to be released in version 3.13.11.6.
> >
> 
> This patch is specifically for parisc, sparc32, tile32, metag-lock1,
> arc-!llsc and hexagon none of which Ubuntu supports.
> 
> Why are you backporting this patch?

Well 3.13.y.z isn't an Ubuntu kernel, its upstream, and those archs
*are* supported.

