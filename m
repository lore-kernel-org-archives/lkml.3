Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab3GLMOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:14:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37060 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab3GLMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:14:14 -0400
Date: Fri, 12 Jul 2013 14:13:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Kyungsik Lee <kyungsik.lee@lge.com>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130712121354.GG24008@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
 <20130712075602.GA4002@gmail.com>
 <20130712080145.GC24008@pd.tnic>
 <20130712101319.GA13421@gmail.com>
 <20130712102326.GE24008@pd.tnic>
 <20130712041810.53c86e5f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130712041810.53c86e5f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:18:10AM -0700, Andrew Morton wrote:
> Well y'know, if whining fixed bugs then there would be no problem here
> at all.

I know. I decided to whine this time and not try to fix it because
attempting to fix every fallout I'm seeing in the tree with randconfigs
is a full-time job and the *actual* job doesn't see any progress.

And in all fairness, if someone were reporting an issue against my code,
I'll try to do my very best to fix it as quickly aas possible, instead
of ignoring it.

So actually, the right thing to do in such cases is back out half-cooked
stuff from the tree until it gets fixed. That'll give the authors the
right incentive. But this is just me.

> This problem came up briefly and I thought it had been adequately
> addressed. Now a month or two later we find out who are the people who
> can't be bothered testing -next, but think it terribly important that
> others do so.

Yeah, if everyone would put their money where their mouth is...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
