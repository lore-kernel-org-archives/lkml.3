Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3HTW6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:58:02 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42194 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3HTW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:58:00 -0400
Date: Tue, 20 Aug 2013 23:57:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.10][3.8][3.5] ARM: Fix FIQ code on VIVT CPUs (was Re:
	[PATCH 076/133] ARM: update FIQ support for relocation of vectors)
Message-ID: <20130820225746.GI17845@n2100.arm.linux.org.uk>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com> <1376692475-28413-77-git-send-email-kamal@canonical.com> <20130818210952.GI3067@blackmetal.musicnaut.iki.fi> <1376928143.18111.12.camel@fourier> <20130819160740.GS23006@n2100.arm.linux.org.uk> <1377039008.20316.79.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377039008.20316.79.camel@fourier>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:50:08PM -0700, Kamal Mostafa wrote:
> On Mon, 2013-08-19 at 17:07 +0100, Russell King - ARM Linux wrote:
> > On Mon, Aug 19, 2013 at 09:02:23AM -0700, Kamal Mostafa wrote:
> > > Thanks Aaro.  I'll apply "2ba85e7 ARM: Fix FIQ code on VIVT CPUs" to
> > > 3.8-stable.
> > > 
> > > Greg KH and Luis Henriques:  Heads up!  3.10-stable and 3.5-stable also
> > > need 2ba85e7 but it isn't marked cc: stable.
> > 
> > There's others from that branch which are probably also needed but I want
> > them to sit in -rc for a bit before I request them to move into the stable
> > trees - in case anyone finds anything more from the security fixes a while
> > back.
> 
> 
> [ 3.8-stable ]
> 
> On Russell's advice I intend to hold off on applying some of the ARM
> security-fixes commits to the imminent v3.8.13.7 release, and instead
> pick them up in the next 3.8-stable cycle.  Specifically:
> 
> These previously announced commits will NOT be included in 3.8.13.7:
> 
>         2ba85e7 ARM: Fix FIQ code on VIVT CPUs
>         f6f91b0 ARM: allow kuser helpers to be removed from the vector page
>         e39e3f3 ARM: update FIQ support for relocation of vectors
> 
> These still WILL be included in 3.8.13.7:
> 
>         0cb79f8 ARM: use linker magic for vectors and vector stubs
>         b9e2c32 ARM: move vector stubs
>         6810219 ARM: poison memory between kuser helpers
>         73c083a ARM: poison the vectors page
> 
> (Aaro, I'll make sure to keep e39e3f3 and 2ba85e7 together when I pick
> them up).
> 
> Any objections?

No, that sounds sensible, thanks.
