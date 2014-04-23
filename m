Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbaDWPBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:01:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51619 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaDWPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:00:57 -0400
Date: Wed, 23 Apr 2014 16:00:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] regulator: First pull of MFD <-> Regulator IB (v3.16)
Message-ID: <20140423150047.GH6264@lee--X1>
References: <20140423113941.GL21613@lee--X1>
 <20140423124629.GA12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140423124629.GA12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Doug Anderson (3):
> >       mfd: tps65090: Don't tell child devices we have an IRQ if we don't
> >       mfd: tps65090: Stop caching most registers
> >       regulator: tps65090: Allow setting the overcurrent wait time
> 
> Can you drop the last one please, I've already applied it?  I'd have
> expected just the first two (or probably even just the second one).  If
> you need it in your tree just grab the branch (or I can tag it if you
> like).
> 
> I tend to apply these things early where they don't have dependencies
> due to the large number of reposts for unrelated changes in the series
> that tend to happen (and often several very similar serieses being in
> flight at once); I frequently end up just deleting them unread.  Not
> sure what the best way to handle this stuff is in general.

I know that you due, which I think makes things easier for you, but
more difficult for everyone else (author, other maintainers). Applying
cross-subsystem patches also makes things difficult down the line.

Not sure what do do about the last patch now, as it has MFD changes
which aren't in the MFD tree. All well and good if no one else touches
that hunk for the remainder of the cycle, but if they do we're likely
to have merge conflicts.

I'll re-spin Monday.

> >  Documentation/devicetree/bindings/regulator/tps65090.txt |  4 ++++
> >  drivers/mfd/tps65090.c                                   | 41 +++++++++++++++++++++++++----------------
> >  drivers/power/tps65090-charger.c                         | 11 -----------
> >  drivers/regulator/tps65090-regulator.c                   | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/tps65090.h                             | 19 +++++++++++++++++++
> >  5 files changed, 104 insertions(+), 27 deletions(-)
> 
> Your formatting for these still seems to be messing up.

How so? Looks fine for me I think?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
