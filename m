Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaEUEZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:25:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59244 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaEUEZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:25:13 -0400
Message-ID: <537C2A72.9030503@zytor.com>
Date: Tue, 20 May 2014 21:24:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
References: <20140521141249.6f87b7e7@canb.auug.org.au>
In-Reply-To: <20140521141249.6f87b7e7@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 09:12 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in 
> arch/x86/kernel/ldt.c between commit fa81511bb0bb ("x86-64,
> modify_ldt: Make support for 16-bit segments a runtime option")
> from Linus' tree and commit 34273f41d57e ("x86, espfix: Make it
> possible to disable 16-bit support") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action is required).
> 

This (and the previous one) is not the correct fix, although it will
work.  The correct fix is instead to completely revert fa81511bb0bb
before merging in tip:x86/espfix.

Sorry for the inconvenience.  Linus generally doesn't like it when we
fix up merges for him, or I'd set up a "clean" tip:x86/espfix branch.

	-hpa

