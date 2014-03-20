Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbaCTTZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:25:04 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:59296 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaCTTZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:25:02 -0400
MIME-Version: 1.0
In-Reply-To: <1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	<20140319154705.GB8557@laptop.programming.kicks-ass.net>
	<20140319170829.GD8557@laptop.programming.kicks-ass.net>
	<20140320053350.GB30295@linux.vnet.ibm.com>
	<1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	<1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
	<1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 20 Mar 2014 12:25:01 -0700
X-Google-Sender-Auth: pHdR1EGVw7PPGrf6NMS-k7hAEB0
Message-ID: <CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 12:08 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Oh, it does. This atomics technique was tested at a customer's site and
> ready for upstream.

I'm not worried about the *original* patch. I'm worried about the
incremental one.

Your original patch never applied to my tree - I think it was based on
-mm or something. So I couldn't verify my "let's go back to the
explicit 'waiters'" incremental patch against reverting and
re-applying the original patch.

So I'd like you to re-verify that that incremental patch really is
solid, and does what your original one did.

               Linus
