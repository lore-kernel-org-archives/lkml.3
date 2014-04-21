Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDUT3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:29:09 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:59901 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDUT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:29:08 -0400
Date: Mon, 21 Apr 2014 21:28:22 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, hskinnemoen@gmail.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:locking/core] arch,avr32: Convert smp_mb__*()
Message-ID: <20140421192822.GA29890@samfundet.no>
References: <tip-8gow97a7mapmnec0pvf729pj@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-8gow97a7mapmnec0pvf729pj@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 18 Apr 2014 06:05:23 -0700 or thereabout, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  710adaa913169d7183cdf0de41c2a349101ff615
> Gitweb:     http://git.kernel.org/tip/710adaa913169d7183cdf0de41c2a349101ff615
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 18 Apr 2014 11:40:33 +0200
> 
> arch,avr32: Convert smp_mb__*()
> 
> AVR32's mb() implementation is a compiler barrier(), therefore it all
> doesn't matter, fully rely on whatever asm-generic/barrier.h
> generates.

Thanks for cleaning, would this go in through some tip-tree? Or would you
prefer if I added it to my for-linus branch?

I currently have nothing in the pipe for 3.15.

> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/n/tip-8gow97a7mapmnec0pvf729pj@git.kernel.org
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/atomic.h | 5 -----
>  arch/avr32/include/asm/bitops.h | 9 ++-------
>  2 files changed, 2 insertions(+), 12 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
