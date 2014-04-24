Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbaDXPDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:03:45 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:52724 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758048AbaDXPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:03:41 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 24 Apr 2014 16:03:27 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
Message-ID: <20140424150327.GL31221@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jiri Kosina <jikos@jikos.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
 <20140424134345.GA20861@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424134345.GA20861@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:43:45PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Like Chris said please test latest drm-intel-nighlty from
> > http://cgit.freedesktop.org/drm-intel to make sure that the recently
> > merged mitigation measures work properly. But those won't get your gpu
> > back, only the display and it's only for 3.16. We're still hunting a
> 
> What does it means "won't get my gpu back, just my display"? Gpu is
> the thing driving the display... no?

We think of it as discrete functional units, i.e. the display engine is
separate from the GPU. What happens here is that the render engine
doesn't respond to our commands to set it up, but that should not
prevent us from setting the register values in the display engine to drive
the actual outputs.
 
> I checked out drm-intel-nightly. Now I can see some kernel messages
> scrolling around on vga console (improvement?), but then end up with
> completely blank screen, and dead machine, AFAICT. Can't seem to ping
> it.

Eeek. Do you have netconsole handy?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
