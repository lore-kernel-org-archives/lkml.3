Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaDLU3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 16:29:52 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62034 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaDLU3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 16:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
	<6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
Date: Sat, 12 Apr 2014 16:29:48 -0400
Message-ID: <CAMzpN2i87GVdrkS=SxN2BZDVpfsM4EqqtkVtNo+R9+MH1B8OMw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this particular game, not 16-bit in general.   The installer, also
16-bit, runs perfectly.  Already filed wine bug 35977.

On Sat, Apr 12, 2014 at 1:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> So Wine regressed and noone noticed? They doesn't sound like an active user base.
>
> On April 11, 2014 9:44:22 PM PDT, Brian Gerst <brgerst@gmail.com> wrote:
>>On Fri, Apr 11, 2014 at 2:50 PM, Linus Torvalds
>><torvalds@linux-foundation.org> wrote:
>>> On Fri, Apr 11, 2014 at 11:45 AM, Brian Gerst <brgerst@gmail.com>
>>wrote:
>>>>
>>>> I haven't tested it recently but I do know it has worked on 64-bit
>>>> kernels.  There is no reason for it not to, the only thing not
>>>> supported in long mode is vm86.  16-bit protected mode is unchanged.
>>>
>>> Afaik 64-bit windows doesn't support 16-bit binaries, so I just
>>> assumed Wine wouldn't do it either on x86-64. Not for any real
>>> technical reasons, though.
>>>
>>> HOWEVER. I'd like to hear something more definitive than "I haven't
>>> tested recently". The "we don't break user space" is about having
>>> actual real *users*, not about test programs.
>>>
>>> Are there people actually using 16-bit old windows programs under
>>> wine? That's what matters.
>>>
>>>                 Linus
>>
>>I just verified that the game does still run on a 64-bit kernel
>>(3.13.8-200.fc20.x86_64).  It needed an older version of Wine, but
>>that's a Wine regression and not kernel related.
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.
