Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3GLMGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:06:20 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43348 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab3GLMGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:06:18 -0400
Date: Fri, 12 Jul 2013 14:06:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Kyungsik Lee <kyungsik.lee@lge.com>,
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
Message-ID: <20130712120613.GA21313@gmail.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
 <20130712075602.GA4002@gmail.com>
 <20130712080145.GC24008@pd.tnic>
 <20130712101319.GA13421@gmail.com>
 <20130712102326.GE24008@pd.tnic>
 <20130712041810.53c86e5f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712041810.53c86e5f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 12 Jul 2013 12:23:26 +0200 Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Fri, Jul 12, 2013 at 12:13:19PM +0200, Ingo Molnar wrote:
> > > and now it is upstream already, via -mm:
> > > 
> > >    e76e1fdfa8f8 lib: add support for LZ4-compressed kernel
> > 
> > Sure. Let's see if it manages to get released b0rked like it is right
> > now.
> 
> Well y'know, if whining fixed bugs then there would be no problem here 
> at all.
> 
> This problem came up briefly and I thought it had been adequately 
> addressed.  Now a month or two later we find out who are the people who 
> can't be bothered testing -next, but think it terribly important that 
> others do so.

At least with my limited resources -next is unusable for my randconfig 
testing. I can randconfig test the fresh new bugs I introduce plus the 
bugs that slip upstream - which naturally peak during the merge window.

Anyway, I hacked it around locally, sh*t happens, it should be easy enough 
to fix.

Thanks,

	Ingo
