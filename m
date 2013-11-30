Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab3LAC22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 21:28:28 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48022 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3LAC20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 21:28:26 -0500
Date: Sat, 30 Nov 2013 17:16:22 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [tip:x86/asm] x86, bitops: Change bitops to be native operand
 size
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Perches <joe@perches.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, james.t.kukunas@intel.com,
        David Miller <davem@davemloft.net>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
	<1384117768.3081.10.camel@joe-AO722>
	<5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
	<1384123457.3081.33.camel@joe-AO722> <52803BA2.2080908@zytor.com>
	<1384136570.4771.5.camel@joe-AO722> <5281698F.9080808@linux.intel.com>
	<1384224883.4771.28.camel@joe-AO722>
	<CA+55aFxsNB0BVg-fdzsu_jkPLpiba1rgTcrUOe7W2tN-mHTnBg@mail.gmail.com>
	<1384229308.4771.35.camel@joe-AO722>
	<CAMuHMdWxRsiFGNBSsoEhyusyDWhuTQS+ecUiPHH1Yaufj43X1g@mail.gmail.com>
In-Reply-To: <CAMuHMdWxRsiFGNBSsoEhyusyDWhuTQS+ecUiPHH1Yaufj43X1g@mail.gmail.com>
	(from geert@linux-m68k.org on Tue Nov 12 02:52:57 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1385853382.1974.297@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 02:52:57 AM, Geert Uytterhoeven wrote:
> On Tue, Nov 12, 2013 at 5:08 AM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2013-11-12 at 12:15 +0900, Linus Torvalds wrote:
> >> Talking about "ideal implementation" is also singularly stupid.
> >
> > I just want the various arch implementations to match
> > the docs.  I know that's stupid.
> >
> > Maybe if you really don't want to discuss things, you
> > should fix the documentation.
> 
> E.g. by adding a paragraph that the actual allowed range of indices  
> may be
> a subset of "unsigned long" on some architectures.
> Or if we know that everyone supports at least 31 resp. 63 bits, that  
> it may
> be limited to 31 resp. 63 unsigned bits, which is the positive range  
> subset of
> "long".

If this ever turns into an actual patch to this file, could you cc: me  
on it so I can marshal it upstream? (Not enough domain expertise for me  
to produce it myself...)

Thanks,

Rob