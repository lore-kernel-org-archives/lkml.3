Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3I0Tlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:41:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60530 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3I0Tle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:41:34 -0400
Date: Fri, 27 Sep 2013 21:41:32 +0200
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
Message-ID: <20130927194132.GA31663@amd.pavel.ucw.cz>
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

On Thu 2013-09-26 17:48:29, Rob Landley wrote:
> On 09/25/2013 11:13:17 AM, Nicolas Pitre wrote:
> >On Wed, 25 Sep 2013, Rob Landley wrote:
> >
> >> On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
> >> > I'd strongly suggest you make your binutils compatible with newer
> >> > instruction syntax instead of making the kernel more complex.
> >>
> >> Meaning I play whack-a-mole as this becomes permission to depend
> >on endless
> >> new gnuisms just because they're there and nobody else is
> >regression testing
> >> against them, not because they actually add anything.
> >
> >Gnuism?
> >
> >Let me quote the ARM ARchitecture Reference Manual, version 7
> >revision C,
> >section A8.8.44 (sorry for the whitespace dammage):
> 
> Globally changing the binutils requirement for all architectures, as
> the doc patch at the start of this thread proposed doing, would mean
> gnuisms in common code (ext2 and such) wouldn't get caught, giving
> llvm and pcc and such a moving target when trying to build the
> kernel with non-gnu toolchains. That's what I meant by gnuisms
> breeding.

Well. I did the docs patch, but my preferred solution would actually
be to get the patches reverted so that it still works with old
binutils.

(So far, I updated one machine with new cross environment, two more to
go.)

Anyway, it should be solved _somehow_.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
