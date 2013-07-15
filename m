Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3GOSp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:45:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43676 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab3GOSp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:45:28 -0400
Message-ID: <51E44234.5060300@zytor.com>
Date: Mon, 15 Jul 2013 11:40:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com> <51E2FACA.3050801@goop.org>
In-Reply-To: <51E2FACA.3050801@goop.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 12:23 PM, Jeremy Fitzhardinge wrote:
> The SDM entry for BT mentions that the instruction may touch 2 or 4
> bytes depending on the operand size, but doesn't specifically mention
> that a 64 bit operation size touches 8 bytes - and it doesn't mention
> anything at all about operand size and access size in BTR/BTS/BTC
> (unless it's implied as part of the discussion about encoding the MSBs
> of a constant bit offset in the offset of the addressing mode). Is that
> an oversight?

Most likely.  I'll check with the people responsible for the SDM here at
Intel.

	-hpa


