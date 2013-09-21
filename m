Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3IUM1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:27:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49850 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3IUM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:27:20 -0400
Date: Sat, 21 Sep 2013 14:27:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luciano Coelho <coelho@ti.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, nsekhar@ti.com,
        mturquette@linaro.org, mark.rutland@arm.com,
        Felipe Balbi <balbi@ti.com>, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/9] wilink: add device tree support
Message-ID: <20130921122718.GA4431@amd.pavel.ucw.cz>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <CANOLnOPBHesTiV61zpQ_QS9c7E91K50EnbMnGhvgaViuA_3=Bw@mail.gmail.com>
 <1372859132.21065.111.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372859132.21065.111.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This is a follow-up on a previous patch set that had a smaller
> > > audience.  This time, I added the lists and people who were involved
> > > in the review of the bindings documentation, since most of my changes
> > > in v2 are coming from discussions there.
> > >
> > > This patch series adds device tree support to the wlcore_sdio driver,
> > > which is used by WiLink6, WiLink7 and WiLink8.
> > 
> > Could you perhaps consider doing device tree conversion for wl1251
> > too? With the knowledge you have from working on this series, it would
> > be much easier for you to do it than for someone else, and I don't
> > have much hope someone will do it at all. It's WiLink series chip
> > after all. Without this pandora and N900 are going to lose wifi
> > support after the switch to dt-only kernel.
> 
> Unfortunately I don't have much time to work on wl1251.  I think it
> wouldn't be too difficult to do though, so patches are welcome. ;)
> 
> Maybe you could try to make this change and I could support you if
> needed?
> 
> 
> > I can offer you my help testing things on pandora and I'm sure someone
> > here could try it on N900.
> 
> I could try it on the N900, if it is still bootable easily with the
> mainline. ;)

3.11 should be bootable on mainline, including device tree and
video. (But excluding some other stuff, like MMC.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
