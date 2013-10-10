Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3JJIev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:34:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59229 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3JJIes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:34:48 -0400
Date: Thu, 10 Oct 2013 10:34:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH] gcc4: Add 'asm goto' miscompilation quirk
Message-ID: <20131010083445.GA10622@gmail.com>
References: <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010082430.GA20577@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Something like the patch below? (Totally untested and all that.)

It's up to 'lightly tested' state on x86: the .config that produced a 
crash before now boots fine, so the workaround appears to work!

Thanks,

	Ingo
