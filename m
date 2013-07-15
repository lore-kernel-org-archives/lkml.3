Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3GOSv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:51:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab3GOSv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:51:28 -0400
Message-ID: <51E4429A.8090500@zytor.com>
Date: Mon, 15 Jul 2013 11:42:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@linux.jf.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <51E2FAB9.9050900@goop.org> <20130714211446.GP5643@tassilo.jf.intel.com>
In-Reply-To: <20130714211446.GP5643@tassilo.jf.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 02:14 PM, Andi Kleen wrote:
> 
> I think best would be to just find some way to implement LOCK prefix
> patching using atomic compiler intrinsics and then switch to those
> 

That will take a long time to make happen now, and then when we change
things we have to wait for gcc to catch up.  At some point this always
degenerates into the "do we need a kernel-specific compiler" morass.

	-hpa


