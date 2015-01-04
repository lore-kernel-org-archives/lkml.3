Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbbADUwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:52:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59485 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbADUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:52:16 -0500
Date: Sun, 4 Jan 2015 21:52:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150104205214.GA32421@amd>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
 <20150104204323.GA12302@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150104204323.GA12302@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2015-01-04 20:43:23, Russell King - ARM Linux wrote:
> On Sun, Jan 04, 2015 at 12:22:36PM -0800, Linus Torvalds wrote:
> > On Sun, Jan 4, 2015 at 12:03 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > >
> > > NAK.
> > 
> > To quote the standard response for people who ignore regressions:
> > 
> >   "SHUT THE FUCK UP"
> > 
> > you cannot NAK regression fixes. Seriously.
> 
> How about we calm down and take some informed view instead of throwing
> mud?  I'd never thought I'd have to be doing this but it seems necessary.
> 
> Yes, it's bad that we now have a userspace breakage from removing the
> bogomips, but a simple revert of the patch doesn't fix it properly.  It
> _may_ seem to get things going again by providing a value, but that
> value may not be what was once provided back in the days that these
> programs were written.

It is the value we had there in 2013, and it seems to be close enough
to value userspace expects there. It is certainly safer/better/closer
than "1.0" Nicolas proposes.

> So, merely reverting the patch doesn't fix the problem.  So, Nico's
> NAK on the simple revert is quite right.

> Instead of throwing insults, what we need to do is to approach this
> calmly, and work out what we can do to fix it properly.

Looking at 9fc2105aeaaf56b0cf75296a84702d0f9e64437b's changelog, I'd
say that insults are not out of place.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
