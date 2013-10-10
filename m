Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3JJOE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:04:27 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52685 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JJOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:04:24 -0400
Message-ID: <5256B3E2.4060401@twiddle.net>
Date: Thu, 10 Oct 2013 07:04:18 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>, Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gcc4: Add 'asm goto' miscompilation quirk
References: <20131009140734.GH3081@twins.programming.kicks-ass.net> <20131009143359.GU26785@twins.programming.kicks-ass.net> <20131009144656.GV26785@twins.programming.kicks-ass.net> <20131009181613.GW30970@tucnak.zalov.cz> <20131009190231.GI13848@laptop.programming.kicks-ass.net> <20131009190851.GX30970@tucnak.zalov.cz> <20131010062238.GB9853@gmail.com> <20131010065104.GY30970@tucnak.zalov.cz> <20131010080457.GC21875@tucnak.zalov.cz> <20131010082430.GA20577@gmail.com> <20131010083107.GZ30970@tucnak.zalov.cz>
In-Reply-To: <20131010083107.GZ30970@tucnak.zalov.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 01:31 AM, Jakub Jelinek wrote:
> Also, for the bitops patch, you probably want an asm_volatile_goto variant.

Why?  Asm without output (which asm goto must be) are automatically volatile.


r!
