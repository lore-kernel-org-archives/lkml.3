Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3GAOu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:50:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54671 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab3GAOu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:50:58 -0400
Date: Mon, 1 Jul 2013 16:50:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701145050.GI23515@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
 <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <19b76ce4-35e0-4f82-b7e9-aa07d5d8af2c@email.android.com>
 <20130701143646.GG23515@pd.tnic>
 <07ca6bb4-2153-48ec-9171-dd7d66720d96@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <07ca6bb4-2153-48ec-9171-dd7d66720d96@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 07:45:41AM -0700, H. Peter Anvin wrote:
> Right... brain not awake yet, sorry, and responding from my phone.
> 
> I am not to worried about trading off a bit of additional branch mispredicts if everything else wins, but Ingo does have a valid question if we are measuring the right thing.
> 
> The effect is definitely big enough that it would be good to understand it one way or the other.
> 
> And regardless of the source... nice job!

Yeah, see my other reply. Ingo's way of tracing this doesn't show any
speedup. So I need to find out now why do I see the speedup the way I
run it.

Keep you posted.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
