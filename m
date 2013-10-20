Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab3JTJSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 05:18:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54584 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab3JTJSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 05:18:16 -0400
Date: Sun, 20 Oct 2013 11:18:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
Message-ID: <20131020091813.GA4972@pd.tnic>
References: <526325C9.7030705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <526325C9.7030705@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 08:37:29PM -0400, Austin S Hemmelgarn wrote:
> This patch adds options to specifically optimize for a number of newer
> 64-bit microarchitectures; specifically, Intel's Nehalem, Westmere,
> Ivy Bridge, and Sandy Bridge, and AMD's Family 10h, Bobcat, Jaguar,
> Bulldozer, Piledriver, and Steamroller. This serves primarily as an
> attempt to render this particular sub-menu up-to-date with respect to
> the options offered by current versions of GCC.

I'm sorry but did I miss anything from the last time where we determined
that those don't bring any sensible speedup and don't mean whit on
distros?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
