Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3GNSeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 14:34:20 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:61981 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3GNSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 14:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0nWO3E2pOLKDds68d_SLA_72e2ok9AV7UvbN6Qa4yAoig@mail.gmail.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
	<CALkWK0nWO3E2pOLKDds68d_SLA_72e2ok9AV7UvbN6Qa4yAoig@mail.gmail.com>
Date: Sun, 14 Jul 2013 11:34:17 -0700
X-Google-Sender-Auth: BPVxwR6HWY_cbhaGTxoj21eieM8
Message-ID: <CA+55aFxK_ORQBJ0Q2f_-xW9e1ESR8e8TYcNmMMaz0zbMyx6mDQ@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
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

On Sun, Jul 14, 2013 at 11:26 AM, Ramkumar Ramachandra
<artagnon@gmail.com> wrote:
>
> I was trying to show a reduced case where gas doesn't complain, but
> llvm-mc does.  Try compiling this with llvm-mc, and you'll get:

Ok. So your commit message and explanation was pure and utter tripe,
and the real reason you want this is that llvm-mc is broken.

Please fix llvm-mc instead, ok? If the intent of llvm is to be
compatible with the gnu compiler tools, then it should do that. Plus
the gas behavior is clearly superior, so why not just improve the llvm
toolchain to match those improved semantics?

                Linus
