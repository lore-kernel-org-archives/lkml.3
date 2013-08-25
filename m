Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3HYMof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 08:44:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab3HYMod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 08:44:33 -0400
Date: Sun, 25 Aug 2013 15:43:29 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Eric Northup <digitaleric@google.com>, Ingo Molnar <mingo@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        habanero@linux.vnet.ibm.com, Rik van Riel <riel@redhat.com>,
        srivatsa.vaddagiri@gmail.com, KVM <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        chegu_vinod@hp.com, drjones@redhat.com, ouyang@cs.pitt.edu,
        Andi Kleen <andi@firstfloor.org>, avi.kivity@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V12 3/5] kvm : Fold pv_unhalt flag into GET_MP_STATE
 ioctl to aid migration
Message-ID: <20130825124329.GP8218@redhat.com>
References: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
 <20130806182309.2386.35697.sendpatchset@codeblue.in.ibm.com>
 <CAG7+5M3_4D+hQn3xWefniKRWzkdraLCJKHG2PrLGPZLJQQUZVA@mail.gmail.com>
 <52014A2C.5080705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52014A2C.5080705@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:40:36AM +0530, Raghavendra K T wrote:
> On 08/07/2013 12:02 AM, Eric Northup wrote:
> >
> >If this is about migration correctness, could it get folded into the
> >previous patch 2/5, so that there's not a broken commit which could
> >hurt bisection?
> 
> Yes. It could be. Only reason I maintained like that was,
> original author in the previous patch is different (Srivatsa) and I did
> not want to merge this hunk when the patch series got evolved to mix
> the sign-offs.
> 
> Gleb, Paolo please let me know.
> 
Yes please, do so.

--
			Gleb.
