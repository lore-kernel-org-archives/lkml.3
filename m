Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaDABhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaDABhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:37:09 -0400
Message-ID: <533A17FD.70005@zytor.com>
Date: Mon, 31 Mar 2014 18:35:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        hubicka@ucw.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
References: <201403312105.s2VL5AqX010173@terminus.zytor.com> <CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com> <20140331230347.GH32556@tassilo.jf.intel.com> <CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com> <20140401010901.GJ32556@tassilo.jf.intel.com>
In-Reply-To: <20140401010901.GJ32556@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 06:09 PM, Andi Kleen wrote:
> 
> I think SYSCALL_DEFINE actually doesn't need it, as the syscall
> tables are visible in C. Only the syscall table itself
> needs to be visible.
> 

I was just going to ask about that.  That really means most asmlinkage
instances don't need it at all.

It is also no secret that I wouldn't mind if we could completely get rid
of asmlinkage, but that requires someone to be willing to dig through
all the i386 assembly code.

	-hpa

