Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaDLTpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 15:45:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbaDLTpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 15:45:21 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140412193541.GA30697@pd.tnic>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com> <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com> <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com> <CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com> <6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com> <20140412193541.GA30697@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 12 Apr 2014 12:44:42 -0700
To: Borislav Petkov <bp@alien8.de>
CC: Brian Gerst <brgerst@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run a 32-bit VM.  The 32-bit kernel does this right.

I suspect it would also work fine in a Qemu user mode guest (is this supported by KVM?), in a ReactOS VM, or some other number of combinations.

The real question is how many real users are actually affected.

On April 12, 2014 12:35:41 PM PDT, Borislav Petkov <bp@alien8.de> wrote:
>On Sat, Apr 12, 2014 at 10:18:25AM -0700, H. Peter Anvin wrote:
>> So Wine regressed and noone noticed? They doesn't sound like an
>active
>> user base.
>
>Btw, wouldn't this obscure use case simply work in a KVM guest with a
>kernel <= 3.14?
>
>Because if so, we simply cut it at 3.14, everything newer has the leak
>fix and people who still want to play phone games on a x86 machine, can
>do so in a guest with an older kernel. Everybody's happy.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
