Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab3LICPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:15:48 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59571 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760197Ab3LICPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:15:45 -0500
Date: Mon, 9 Dec 2013 02:15:44 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: bcousson@baylibre.com, Roger Quadros <rogerq@ti.com>,
        tomi.valkeinen@ti.com, balbi@ti.com, sr@denx.de,
        David.Laight@ACULAB.COM, michael@amarulasolutions.com,
        bigeasy@linutronix.de, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: OMAP4+: hwmod data: Don't prevent RESET of USB
 Host module
In-Reply-To: <20131209015838.GA11433@atomide.com>
Message-ID: <alpine.DEB.2.02.1312090213210.32309@utopia.booyaka.com>
References: <1386080748-17005-1-git-send-email-rogerq@ti.com> <1386080748-17005-2-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1312090125170.32309@utopia.booyaka.com> <20131209015838.GA11433@atomide.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-894948885-1386555344=:32309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-894948885-1386555344=:32309
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 8 Dec 2013, Tony Lindgren wrote:

> * Paul Walmsley <paul@pwsan.com> [131208 17:27]:
> > On Tue, 3 Dec 2013, Roger Quadros wrote:
> >=20
> > > Without this, the USB devices are sometimes not detected on OMAP4 Pan=
da
> > > with u-boot v2013.10.
> > >=20
> > > Unlike what the comment states, errata i660 does not state that we
> > > can't RESET the USB host module. Instead it states that RESET is the
> > > only way to recover from a deadlock situation.
> > >=20
> > > RESET ensures that the module is in a known good state irrespective
> > > of what bootloader does with the module, so it must be done at boot.
> > >=20
> > > Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > Signed-off-by: Roger Quadros <rogerq@ti.com>
> >=20
> > Acked-by: Paul Walmsley <paul@pwsan.com>
> >=20
> > Will you pick this up for the -rc series, or do you want me or Tony to?=
 =20
> > Roger writes that this one's pretty important.
>=20
> I suggest that you just queue this with your other fixes so we get
> things working.

I'm going to wait until tomorrow anyway to see if Sathya responds to my=20
other E-mail, so maybe Beno=C3=AEt will let us know by then.


- Paul
--843723315-894948885-1386555344=:32309--
