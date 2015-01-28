Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbbA1UOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:14:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54227 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbbA1UOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:07 -0500
Date: Wed, 28 Jan 2015 09:25:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150128082536.GA2270@amd>
References: <201501271532.25540@pali>
 <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr>
 <20150127210943.GN26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
 <20150127223331.GP26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr>
 <1FECE32B-0D63-4696-BED7-74FE5845C260@jcrosoft.com>
 <20150128071950.GB29927@amd>
 <F2E2E152-2054-4284-9DAC-67FEC30DF399@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F2E2E152-2054-4284-9DAC-67FEC30DF399@jcrosoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2015-01-28 16:06:17, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On Jan 28, 2015, at 3:19 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > Hi!
> > 
> >>> In other words, what prevents someone from creating, say, a custom 
> >>> minimal Barebox version that sits on top of the existing N900 
> >>> bootloader?  Wouldn't that provide a much better user experience?
> >> 
> >> I do agree with Nicolas
> >> 
> >> If I can get my hand on a phone I’ll put barebox on it
> > 
> > Grab it in the nearest "second hand cellphones" shop, and have fun! It
> > should be less than $70.
> 
> will see if I can found one in Shanghai at the second hand market
> 
> Does it exist a qemu emulation?

Yes, linaro-qemu supports it. (But people are trying to break it
"because it is not real hardware so it can be fixed").

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
