Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaLMRrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 12:47:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56671 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaLMRq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 12:46:56 -0500
Date: Sat, 13 Dec 2014 18:46:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Maintainer abuse
Message-ID: <20141213174652.GD29934@pd.tnic>
References: <alpine.DEB.2.11.1412130016090.16494@nanos>
 <20141212234336.GA28451@pd.tnic>
 <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 01:52:31PM +0000, One Thousand Gnomes wrote:

...

> It could then be integrated into git (if only so we can have a "git lost"
> command to block annoying sources)

All sounds nice and good but I'd be fine with people adhering to the
one-week feedback gather rule and not sending patchsets during the merge
window, for starters. I think those two will get us pretty far.

> 2. Is X86 moving at a rate which needs some additional maintainers to
> "maintain" the pending queue during merge windows and the like, and get
> stuff into order for the maintainers proper ?

Yep, no patches during the merge window should be a good start.

The rest of the time x86 actually scales pretty fine IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
