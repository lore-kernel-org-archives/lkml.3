Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab3KLDPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 22:15:46 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:50904 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3KLDPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 22:15:37 -0500
MIME-Version: 1.0
In-Reply-To: <1384224883.4771.28.camel@joe-AO722>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
	<1384117768.3081.10.camel@joe-AO722>
	<5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
	<1384123457.3081.33.camel@joe-AO722>
	<52803BA2.2080908@zytor.com>
	<1384136570.4771.5.camel@joe-AO722>
	<5281698F.9080808@linux.intel.com>
	<1384224883.4771.28.camel@joe-AO722>
Date: Tue, 12 Nov 2013 12:15:36 +0900
X-Google-Sender-Auth: phVW-pdku0BtRQykQuhqI3nmb4o
Message-ID: <CA+55aFxsNB0BVg-fdzsu_jkPLpiba1rgTcrUOe7W2tN-mHTnBg@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86, bitops: Change bitops to be native operand size
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, james.t.kukunas@intel.com,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:54 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-11-11 at 15:34 -0800, H. Peter Anvin wrote:
>> On 11/10/2013 06:22 PM, Joe Perches wrote:
>> >
>> > Perhaps the current x86 bitops asm code is being conflated
>> > with the ideal implementation?
>> >
>> Yes, by you.
>
> Really?  I don't think so.

What you think in this case doesn't really matter, does it? There are
actual facts, and then there is your thinking, and guess which one
matters?

Peter is absolutely correct, and has shown remarkable restraint trying
to explain it to you. The fact is, the x86 bitop instructions act on a
signed index. Making the index be "unsigned long" would violate the
actual *behavior* of the function, so it would be singularly stupid.

Talking about "ideal implementation" is also singularly stupid.
There's this fascinating thing called "reality", and you should try to
re-aquaint yourself with it.

Don't bother replying to this thread.

               Linus
