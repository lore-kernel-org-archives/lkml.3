Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaDLULj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 16:11:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41073 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbaDLULh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 16:11:37 -0400
Date: Sat, 12 Apr 2014 22:11:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
Message-ID: <20140412201126.GC30694@pd.tnic>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
 <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
 <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
 <CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
 <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
 <20140412193541.GA30697@pd.tnic>
 <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 12:44:42PM -0700, H. Peter Anvin wrote:
> Run a 32-bit VM.  The 32-bit kernel does this right.

Yes, even better.

> I suspect it would also work fine in a Qemu user mode guest (is
> this supported by KVM?), in a ReactOS VM, or some other number of
> combinations.

Right.

So basically, there a lot of different virt scenarios which can all take
care of those use cases *without* encumbering some insane solutions on
64-bit.

> The real question is how many real users are actually affected.

And if they are, virtualize them, for chrissake. It is time we finally
used virt for maybe one of its major use cases - virtualize old/obscure
hw. It should be pretty reliable by now.

:-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
