Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaDLVkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 17:40:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50109 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaDLVkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 17:40:45 -0400
Date: Sat, 12 Apr 2014 23:40:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brian Gerst <brgerst@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
Message-ID: <20140412214034.GF30694@pd.tnic>
References: <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
 <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
 <CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
 <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
 <20140412193541.GA30697@pd.tnic>
 <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
 <20140412201126.GC30694@pd.tnic>
 <CAMzpN2jHrBZ7DCd79GkCdjwCWJBv+YR5o9BGjypCdazJB9bJYQ@mail.gmail.com>
 <20140412205920.GD30694@pd.tnic>
 <CAMzpN2hkfw0p71H9QLFvbdmuiYqXqXJwBHK=GY_U_VHfjBL4Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMzpN2hkfw0p71H9QLFvbdmuiYqXqXJwBHK=GY_U_VHfjBL4Lg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 05:13:40PM -0400, Brian Gerst wrote:
> Performance is bad in general, running a 32-bit Fedora 20 guest.

So this means you haven't tried the game in the guest yet, so that we
can know for sure that a guest doesn't solve your problem or what?

Btw, which game is that and can I get it somewhere to try it here
locally?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
