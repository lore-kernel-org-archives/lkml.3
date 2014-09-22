Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaIVUUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:20:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61540 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaIVUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140922200716.GB3128@worktop.programming.kicks-ass.net>
References: <1411415590-12193-1-git-send-email-bobby.prani@gmail.com> <20140922200716.GB3128@worktop.programming.kicks-ass.net>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 22 Sep 2014 16:20:08 -0400
Message-ID: <CAJhHMCCCWN+poNmNL0Q6B1RHJAETOsgMCAykm1GmiL18BtKfAg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86: Use ACCESS_ONCE() for atomic_read()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 4:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Sep 22, 2014 at 03:53:09PM -0400, Pranith Kumar wrote:
>> Use the much easier to read ACCESS_ONCE() which is basically the same thing as
>> the cast to volatile.
>>
>> Please note the change in volatile cast: ACCESS_ONCE(v)->counter to
>> ACCESS_ONCE(v->counter).
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> ---
>>  arch/x86/include/asm/atomic.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> If you want to do something like so, then be consistent and do them all.

Sure, I will change this in all architectures and send in an updated patch.

Thanks!
-- 
Pranith
