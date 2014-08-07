Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaHGCAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 22:00:43 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54073 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaHGCAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 22:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <1407376502.12474.64.camel@fourier>
References: <1407358496-23094-1-git-send-email-kamal@canonical.com>
	<CAJUuVQ5OpNye8HAEw6x=owBB32pq-aLF7_Gqo493jDDHDahhRA@mail.gmail.com>
	<1407360614.3395.2.camel@buesod1.americas.hpqcorp.net>
	<1407376502.12474.64.camel@fourier>
Date: Wed, 6 Aug 2014 22:00:39 -0400
Message-ID: <CAJUuVQ4q8wN+iR84gkGgP-ax6pUY4oWFa83aH+LXwZFricgwXg@mail.gmail.com>
Subject: Re: [3.13.y.z extended stable] Patch "locking/mutex: Disable
 optimistic spinning on some architectures" has been added to staging queue
From: Andev <debiandev@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 9:55 PM, Kamal Mostafa <kamal@canonical.com> wrote:
>
> On Wed, 2014-08-06 at 14:30 -0700, Davidlohr Bueso wrote:
>> Well 3.13.y.z isn't an Ubuntu kernel, its upstream, and those archs
>> *are* supported.
>
> Davidlohr's answer is correct: This is not an "Ubuntu kernel".
>
> 3.13.y.z is an "extended stable" kernel which follows the same rules as
> the kernel.org official stable kernels.  It contains no Ubuntu-specific
> patches, and supports the same arch's as mainline.
>
> More details about this and the other Canonical-funded-and-hosted
> "extended stable" kernel versions is available here:
>
>> For more information about the 3.13.y.z tree, see
>> https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

OK, thank you for clarification. I was unsure as this is not hosted on
kernel.org, I thought it was a Ubuntu specific kernel.

So we have the following stable kernels as of now:

3.10, 3.12, 3.13, 3.14, 3.15(for a few days), 3.16!

Interesting.
-- 
Andev
