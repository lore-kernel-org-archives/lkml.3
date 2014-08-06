Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaHFVZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:25:05 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54297 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaHFVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <1407358496-23094-1-git-send-email-kamal@canonical.com>
References: <1407358496-23094-1-git-send-email-kamal@canonical.com>
Date: Wed, 6 Aug 2014 17:25:02 -0400
Message-ID: <CAJUuVQ5OpNye8HAEw6x=owBB32pq-aLF7_Gqo493jDDHDahhRA@mail.gmail.com>
Subject: Re: [3.13.y.z extended stable] Patch "locking/mutex: Disable
 optimistic spinning on some architectures" has been added to staging queue
From: Andev <debiandev@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
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
        Davidlohr Bueso <davidlohr@hp.com>,
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

On Wed, Aug 6, 2014 at 4:54 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> This is a note to let you know that I have just added a patch titled
>
>     locking/mutex: Disable optimistic spinning on some architectures
>
> to the linux-3.13.y-queue branch of the 3.13.y.z extended stable tree
> which can be found at:
>
>  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.13.y-queue
>
> This patch is scheduled to be released in version 3.13.11.6.
>

This patch is specifically for parisc, sparc32, tile32, metag-lock1,
arc-!llsc and hexagon none of which Ubuntu supports.

Why are you backporting this patch?

--
Andev
