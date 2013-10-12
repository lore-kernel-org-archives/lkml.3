Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3JLRDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:03:45 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:41440 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3JLRDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:03:44 -0400
Date: Sat, 12 Oct 2013 19:03:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131012170340.GA15988@gmail.com>
References: <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
 <20131010151219.GC5167@gmail.com>
 <20131011043553.GA9015@localhost>
 <20131011054655.GA28077@gmail.com>
 <20131011065149.GA16470@localhost>
 <20131011093029.GA30308@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011093029.GA30308@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fengguang Wu <fengguang.wu@intel.com> wrote:

> Ingo,
> 
> After adding more test runs to these kernels, we can see that the boot hangs
> happen both before/after patch. So the patch is fine. 
> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>

Cool, thanks for all the testing - I'll send the fix to Linus.

> btw, the boot hangs all happen in one of the test boxes, which is 
> probably misconfigured or not reliable.

... or somehow has hardware layout/properties that triggers a particularly 
nasty kernel bug.

Thanks,

	Ingo
