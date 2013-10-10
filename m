Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3JJQPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:15:37 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:46115 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3JJQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:15:36 -0400
Message-ID: <5256D2A2.5060202@twiddle.net>
Date: Thu, 10 Oct 2013 09:15:30 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Jakub Jelinek <jakub@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto' miscompilation
 bug
References: <20131009181613.GW30970@tucnak.zalov.cz> <20131009190231.GI13848@laptop.programming.kicks-ass.net> <20131009190851.GX30970@tucnak.zalov.cz> <20131010062238.GB9853@gmail.com> <20131010065104.GY30970@tucnak.zalov.cz> <20131010080457.GC21875@tucnak.zalov.cz> <20131010082430.GA20577@gmail.com> <20131010083107.GZ30970@tucnak.zalov.cz> <5256B3E2.4060401@twiddle.net> <20131010142703.GI30970@tucnak.zalov.cz> <20131010151219.GC5167@gmail.com>
In-Reply-To: <20131010151219.GC5167@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 08:12 AM, Ingo Molnar wrote:
> Indeed. Something like the updated version below?
> 
> [ I kept the asm_volatile_goto() naming to make sure the implicit volatile 
>   is visible. ]
> 
> Thanks,
> 
> 	Ingo

Looks good.

Reviewed-by: Richard Henderson <rth@twiddle.net>


r~
