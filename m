Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3KLIxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:53:01 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43566 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3KLIw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:52:57 -0500
MIME-Version: 1.0
In-Reply-To: <1384229308.4771.35.camel@joe-AO722>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
	<1384117768.3081.10.camel@joe-AO722>
	<5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
	<1384123457.3081.33.camel@joe-AO722>
	<52803BA2.2080908@zytor.com>
	<1384136570.4771.5.camel@joe-AO722>
	<5281698F.9080808@linux.intel.com>
	<1384224883.4771.28.camel@joe-AO722>
	<CA+55aFxsNB0BVg-fdzsu_jkPLpiba1rgTcrUOe7W2tN-mHTnBg@mail.gmail.com>
	<1384229308.4771.35.camel@joe-AO722>
Date: Tue, 12 Nov 2013 09:52:57 +0100
X-Google-Sender-Auth: 3b1PftsXRAyKz54WxBRVjfQZbeg
Message-ID: <CAMuHMdWxRsiFGNBSsoEhyusyDWhuTQS+ecUiPHH1Yaufj43X1g@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86, bitops: Change bitops to be native operand size
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, james.t.kukunas@intel.com,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 5:08 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-11-12 at 12:15 +0900, Linus Torvalds wrote:
>> Talking about "ideal implementation" is also singularly stupid.
>
> I just want the various arch implementations to match
> the docs.  I know that's stupid.
>
> Maybe if you really don't want to discuss things, you
> should fix the documentation.

E.g. by adding a paragraph that the actual allowed range of indices may be
a subset of "unsigned long" on some architectures.
Or if we know that everyone supports at least 31 resp. 63 bits, that it may
be limited to 31 resp. 63 unsigned bits, which is the positive range subset of
"long".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
