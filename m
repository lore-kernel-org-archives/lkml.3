Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3IVNgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 09:36:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55566 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3IVNgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 09:36:33 -0400
Date: Sun, 22 Sep 2013 15:36:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luciano Coelho <coelho@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
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
Message-ID: <20130922133632.GB8643@amd.pavel.ucw.cz>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <CANOLnOPBHesTiV61zpQ_QS9c7E91K50EnbMnGhvgaViuA_3=Bw@mail.gmail.com>
 <1372859132.21065.111.camel@cumari.coelho.fi>
 <20130921122718.GA4431@amd.pavel.ucw.cz>
 <20130921141614.GA21383@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130921141614.GA21383@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Unfortunately I don't have much time to work on wl1251.  I think it
> > > wouldn't be too difficult to do though, so patches are welcome. ;)
> > > 
> > > Maybe you could try to make this change and I could support you if
> > > needed?
> > > 
> > > 
> > > > I can offer you my help testing things on pandora and I'm sure someone
> > > > here could try it on N900.
> > > 
> > > I could try it on the N900, if it is still bootable easily with the
> > > mainline. ;)
> > 
> > 3.11 should be bootable on mainline, including device tree and
> > video. (But excluding some other stuff, like MMC.)
> 
> I got external MMC (=> µSD) working with some small modifications of
> the omap3-n900.dts file. I have not yet tried internal MMC, since
> its not important for me at the moment, but I guess its also just a
> small change in the dts file.

Can we get the diff? :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
