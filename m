Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaDWWD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:03:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53255 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDWWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:03:09 -0400
Date: Thu, 24 Apr 2014 00:03:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
Message-ID: <20140423220307.GA4626@amd.pavel.ucw.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-04-23 23:09:45, Daniel Vetter wrote:
> On Wed, Apr 23, 2014 at 10:22 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > After update to 3.15-rc2, only top 20% of screen works on X.
> >
> > 00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset
> > Integrated Graphics Controller (rev 03)
> >
> > 00:02.1 Display controller: Intel Corporation 4 Series Chipset
> > Integrated Graphics Controller (rev 03)
> >            Subsystem: Intel Corporation Device d614
> >            Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> >            ParErr- Stepping- SERR- FastB2B- DisINTx-
> >            Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast
> >            >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >            Latency: 0
> >            Region 0: Memory at d0400000 (64-bit, non-prefetchable)
> >            [size=1M]
> >            Capabilities: <access denied>
> >
> > This worked before. I believe it worked in 3.14. It definitely works
> > in 3.11-rc2.
> 
> Screenshot or more detailed description of what "only top 20% of
> screen works in X" means?

Well, top cca 20% is ok, then I got repeated pattern of some part of screen.

> Anything in dmesg?

That will take a look.

> bisect result presuming that it reproduces reliably?

If there's no other chance, I guess I could do bisect. But
first.... Do you have similar hardware? Does it work for you? Are
there any experimental changes that went in recently and I should
try reverting first?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
