Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaDLUeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 16:34:18 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:42335 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaDLUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 16:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140412201126.GC30694@pd.tnic>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
	<6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
	<20140412193541.GA30697@pd.tnic>
	<21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
	<20140412201126.GC30694@pd.tnic>
Date: Sat, 12 Apr 2014 16:34:14 -0400
Message-ID: <CAMzpN2jHrBZ7DCd79GkCdjwCWJBv+YR5o9BGjypCdazJB9bJYQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Brian Gerst <brgerst@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 4:11 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Apr 12, 2014 at 12:44:42PM -0700, H. Peter Anvin wrote:
>> Run a 32-bit VM.  The 32-bit kernel does this right.
>
> Yes, even better.
>
>> I suspect it would also work fine in a Qemu user mode guest (is
>> this supported by KVM?), in a ReactOS VM, or some other number of
>> combinations.
>
> Right.
>
> So basically, there a lot of different virt scenarios which can all take
> care of those use cases *without* encumbering some insane solutions on
> 64-bit.
>
>> The real question is how many real users are actually affected.
>
> And if they are, virtualize them, for chrissake. It is time we finally
> used virt for maybe one of its major use cases - virtualize old/obscure
> hw. It should be pretty reliable by now.
>
> :-P
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --

My experience with kvm so far is that is slow and clunky.  It may be
OK for a server environment, but interactively it's difficult to use.
