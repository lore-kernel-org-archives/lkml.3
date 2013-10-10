Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3JJQt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:49:28 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41904 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3JJQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:49:27 -0400
Date: Thu, 10 Oct 2013 18:49:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Richard Henderson <rth@twiddle.net>
Cc: Jakub Jelinek <jakub@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131010164923.GA12998@gmail.com>
References: <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
 <20131010151219.GC5167@gmail.com>
 <5256D2A2.5060202@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5256D2A2.5060202@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard Henderson <rth@twiddle.net> wrote:

> On 10/10/2013 08:12 AM, Ingo Molnar wrote:
> > Indeed. Something like the updated version below?
> > 
> > [ I kept the asm_volatile_goto() naming to make sure the implicit volatile 
> >   is visible. ]
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Looks good.
> 
> Reviewed-by: Richard Henderson <rth@twiddle.net>

The question then would be, does it solve Fengguang's crashes as well? He 
was able to reproduce them faster than I.

Thanks,

	Ingo
