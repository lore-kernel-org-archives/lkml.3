Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaBMJn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:43:59 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35140 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBMJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:43:55 -0500
Date: Thu, 13 Feb 2014 10:43:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Noonan <steven@uplinklabs.net>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jakub Jelinek <jakub@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20140213094352.GA6782@gmail.com>
References: <20131012171007.GA17167@gmail.com>
 <CAKbGBLgs9t4HPD4duBt=vPaw0WfxLv5qr6pNupHsPTFaV5m+dQ@mail.gmail.com>
 <CA+55aFys_VK+q3LMRzEM-AKU-=fM_tgiDdLm2AO=jVfH7OvrHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFys_VK+q3LMRzEM-AKU-=fM_tgiDdLm2AO=jVfH7OvrHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 12, 2014 at 7:09 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> >
> > If I change the GCC_VERSION check for the asm_volatile_goto quirk to
> > include 4.8.2, then KVM guests are properly cleaned up.
> 
> Ok, I guess that means we should just make the quirk unconditional.
> 
> Ingo, do you want to do that or should I?

Yeah, will pick up Steven's patch later today unless you beat me at 
it. If you pick it up yourself:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
