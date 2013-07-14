Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3GNStr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 14:49:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34521 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3GNStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 14:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxK_ORQBJ0Q2f_-xW9e1ESR8e8TYcNmMMaz0zbMyx6mDQ@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
 <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
 <CALkWK0nWO3E2pOLKDds68d_SLA_72e2ok9AV7UvbN6Qa4yAoig@mail.gmail.com> <CA+55aFxK_ORQBJ0Q2f_-xW9e1ESR8e8TYcNmMMaz0zbMyx6mDQ@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 15 Jul 2013 00:19:05 +0530
Message-ID: <CALkWK0k7TyfU55TjoDWwgxpXwiY_F1-o6LYjFXkiHeFoKmK6FQ@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Ok. So your commit message and explanation was pure and utter tripe,
> and the real reason you want this is that llvm-mc is broken.
>
> Please fix llvm-mc instead, ok? If the intent of llvm is to be
> compatible with the gnu compiler tools, then it should do that. Plus
> the gas behavior is clearly superior, so why not just improve the llvm
> toolchain to match those improved semantics?

Yep.  I started the discussion on LLVMDev, and posted patches [1].
>From the discussions on the list, many of the devs are claiming that
LLVM is "correct" and that linux.git needs to be patched.  I'm not
taking sides; I just want a solution to the problem.

[1]: The archive is broken, but here are some pieces:
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20130708/180968.html
