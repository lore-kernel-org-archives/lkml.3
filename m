Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab3K0W3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:29:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46204 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab3K0W3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:29:52 -0500
Date: Wed, 27 Nov 2013 23:29:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131127222944.GB748@pd.tnic>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
 <5294F10C.8060901@amacapital.net>
 <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
 <52964EC7.9000504@zytor.com>
 <52966C0A.7070201@zytor.com>
 <20131127222104.GA748@pd.tnic>
 <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 02:25:29PM -0800, H. Peter Anvin wrote:
> Actually the CPUID is superfluous on anything than the executing CPU
> since IRET is serializing.

Why not on the executing core too? We're IRET-ting there too.

Which would mean that a dummy empty syscall would be enough too since we
need the serialization only.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
