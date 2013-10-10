Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3JJO1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:27:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab3JJO1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:27:37 -0400
Date: Thu, 10 Oct 2013 16:27:03 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gcc4: Add 'asm goto' miscompilation quirk
Message-ID: <20131010142703.GI30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5256B3E2.4060401@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:04:18AM -0700, Richard Henderson wrote:
> On 10/10/2013 01:31 AM, Jakub Jelinek wrote:
> > Also, for the bitops patch, you probably want an asm_volatile_goto variant.
> 
> Why?  Asm without output (which asm goto must be) are automatically volatile.

You're right.

	Jakub
