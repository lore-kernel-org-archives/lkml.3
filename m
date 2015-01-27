Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbbA0XKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:10:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55218 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbbA0XKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:10:09 -0500
Date: Wed, 28 Jan 2015 00:10:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150127231007.GA27641@amd>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127132127.GA869@amd>
 <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
 <201501271532.25540@pali>
 <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr>
 <20150127210943.GN26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Useful when properly designed and generic enough to be shared.
> > > 
> > > I'd suggest a DT property be proposed for that purpose if it doesn't 
> > > already exist.  That at least has a chance to be generically useful.
> > 
> > What this means is that we have to further augment the atags-to-dt code
> > in the decompressor with the platform specific ATAGs to parse this
> > information and merge it into the appended DT before passing the
> > resulting DT blob to the kernel.
> 
> That would be only 2 new lines of code in the best case.

Yes, instead of 2 new lines of code, let people write, debug, and
flash 1000 lines shim. Completely makes sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
