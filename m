Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3I1Inc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:43:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42867 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3I1Ina (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:43:30 -0400
Date: Sat, 28 Sep 2013 10:43:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: new binutils needed for arm in 3.12-rc1
Message-ID: <20130928084328.GA5649@amd.pavel.ucw.cz>
References: <alpine.LFD.2.03.1309251147320.312@syhkavp.arg>
 <1380235709.1974.93@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380235709.1974.93@driftwood>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Given you're not upgrading your binutils anymore that means
> >you'll have to apply that patch only once instead of having to
> >apply it
> >to every kernel upgrade.
> 
> Indeed. Patching my own toolchain isn't really a problem. My
> objection was to the Documentation patch telling the world at large
> that for all targets, older binutils aren't supported even on x86.
> That was worth pushing back against.
> 
> I don't indend to use old gcc/binutils versions forever, I just want
> to be able to use them until I can replace them with llvm or
> similar.

So, what is the proposal? Just ignore the problem and make people
wonder why their arm kernels are not compiling?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
