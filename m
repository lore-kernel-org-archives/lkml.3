Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaCFNpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:45:07 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34488 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaCFNpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:45:05 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Khalid Aziz <khalid.aziz@oracle.com>,
        tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Organization: D03
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<531641A8.40306@zytor.com> <87ob1jbgtg.fsf@rasmusvillemoes.dk>
	<20140306133450.GL9987@twins.programming.kicks-ass.net>
X-Hashcash: 1:20:140306:linux-kernel@vger.kernel.org::g5KzUNjbXjlqUZLK:0000000000000000000000000000000000JyD
X-Hashcash: 1:20:140306:venki@google.com::YB2zYC1AHaLxCV+5:00ZV0
X-Hashcash: 1:20:140306:viro@zeniv.linux.org.uk::EL+6OcJu5tfGcTK0:000000000000000000000000000000000000000GTN
X-Hashcash: 1:20:140306:mingo@kernel.org::KJFYFaeeOuI0QNPj:01B2P
X-Hashcash: 1:20:140306:rob@landley.net::V4wAO0giI0c412Df:001AE4
X-Hashcash: 1:20:140306:peterz@infradead.org::Fh6RB8J0eqGXwnbM:000000000000000000000000000000000000000001IMV
X-Hashcash: 1:20:140306:tglx@linutronix.de::wgHe5Y4irBFiTODH:00000000000000000000000000000000000000000003qq+
X-Hashcash: 1:20:140306:oleg@redhat.com::F3MJeIXqeBi3tV1i:004ROR
X-Hashcash: 1:20:140306:andi.kleen@intel.com::CcE5Iu/f5GSsF/EY:000000000000000000000000000000000000000004Ho5
X-Hashcash: 1:20:140306:akpm@linux-foundation.org::OpmurtwyW3pNo98x:0000000000000000000000000000000000005PyB
X-Hashcash: 1:20:140306:khalid.aziz@oracle.com::OS7JYKzbLELW2xax:00000000000000000000000000000000000000082jO
X-Hashcash: 1:20:140306:hpa@zytor.com::Yx05qzpT1p7aZSyb:0000NQqD
Date: Thu, 06 Mar 2014 14:45:00 +0100
In-Reply-To: <20140306133450.GL9987@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 6 Mar 2014 14:34:50 +0100")
Message-ID: <87k3c7bfvn.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, Mar 06, 2014 at 02:24:43PM +0100, Rasmus Villemoes wrote:
>> Is it possible to implement non-sleeping versions of {get,put}_user()?
>
> __{get,put}_user()

Huh?

arch/x86/include/asm/uaccess.h:

/**
 * __get_user: - Get a simple variable from user space, with less checking.
 * @x:   Variable to store result.
 * @ptr: Source address, in user space.
 *
 * Context: User context only.  This function may sleep.

What am I missing?

Rasmus

