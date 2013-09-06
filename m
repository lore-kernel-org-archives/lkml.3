Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3IFUfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:35:24 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52669 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3IFUfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:35:23 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2] Camera drivers for Nokia RX-51
Date: Fri, 6 Sep 2013 22:35:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201302171616.50152@pali> <20130403222228.GE10541@valkosipuli.retiisi.org.uk> <2135333.iYIDmYH7CC@avalon>
In-Reply-To: <2135333.iYIDmYH7CC@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2043704.XG09jN2rnN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309062235.18603@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2043704.XG09jN2rnN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 04 April 2013 15:11:27 Laurent Pinchart wrote:
> Hi Sakari,
>=20
> On Thursday 04 April 2013 01:22:28 Sakari Ailus wrote:
> > On Tue, Mar 26, 2013 at 12:07:01AM +0100, Laurent Pinchart=20
wrote:
> > > On Sunday 24 March 2013 23:46:01 Sakari Ailus wrote:
> > > > Pali Roh=C3=A1r wrote:
> > > > > On Thursday 07 March 2013 23:18:27 Sakari Ailus wrote:
> > > > >> On Wed, Mar 06, 2013 at 10:44:41PM +0100, Sebastian=20
Reichel wrote:
> > > > >>> On Wed, Mar 06, 2013 at 09:20:16PM +0100, Pali Roh=C3=A1r=20
wrote:
> > > > >>>> On Wednesday 06 March 2013 21:12:06 Pali Roh=C3=A1r=20
wrote:
> > > > >>>>> On Sunday 17 February 2013 20:03:03 Aaro Koskinen=20
wrote:
> > > > >>>>>> On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali=20
Roh=C3=A1r wrote:
> > > > >>>>>>> +/*
> > > > >>>>>>> + * arch/arm/mach-omap2/board-rx51-camera.c
> > > > >>>>>>> + *
> > > > >>>>>>> + * Copyright (C) 2008 Nokia Corporation
> > > > >>>>>>> + *
> > > > >>>>>>> + * Contact: Sakari Ailus
> > > > >>>>>>> <sakari.ailus@nokia.com> + *          Tuukka
> > > > >>>>>>> Toivonen <tuukka.o.toivonen@nokia.com>
> > > > >>>>>>=20
> > > > >>>>>> You should put these people to CC... Just to see
> > > > >>>>>> if the addresses are still valid (which I
> > > > >>>>>> doubt).
> > > > >>>>>=20
> > > > >>>>> Ok, trying :-)
> > > > >>>>=20
> > > > >>>> I got "Delivery Status Notification (Failure)" for
> > > > >>>> both addresses.
> > > > >>=20
> > > > >> This is expected.
> > > > >>=20
> > > > >>> Sakari Ailus hosts some code on github [0], which
> > > > >>> has the following email address:
> > > > >>> sakari.ailus+gitorious@retiisi.org.uk
> > > > >>>=20
> > > > >>> I added it to this mail's CC.
> > > > >>>=20
> > > > >>> [0] https://gitorious.org/~sailus
> > > > >>=20
> > > > >> Nice to hear people are interested in this. ;-)
> > > > >>=20
> > > > >> The primary reason I haven't tried submitting this to
> > > > >> mainline is that ARM board code has a bad reputation
> > > > >> these days. The N900 does not have yet support for
> > > > >> device tree (AFAIK), which also would require a few
> > > > >> bits and pieces on the flash driver to work.
> > > > >>=20
> > > > >> Also the sensor and lens drivers would need at least
> > > > >> some work before being ready for submission to
> > > > >> mainline for camera to be usable. Unfortunately I
> > > > >> haven't had recently time to work on this. N9(50)
> > > > >> support has higher priority for myself. That, too,
> > > > >> is pending the DT support for the device.
> > > > >>=20
> > > > >> There's indeed more up-to-date code in my repository.
> > > > >> Even if it's not too close to mainline anymore it
> > > > >> should be a better starting point than the old
> > > > >> kernel from MeeGo.
> > > > >>=20
> > > > >> <URL:https://gitorious.org/omap3camera/pages/Home>
> > > > >=20
> > > > > Hi,
> > > > >=20
> > > > > this board code is same in your git repository and on
> > > > > meego obs.
> > > > >=20
> > > > > Patch only adding support for adp1653 driver which is
> > > > > already in upstream kernel.
> > > > >=20
> > > > > Are there any other problems with this patch to go for
> > > > > upstream?
> > > >=20
> > > > A few more things comes to mind. We depend a little bit
> > > > on actual board code; it's not only static data. That's
> > > > the configuration of the external clock from the ISP to
> > > > the sensor. That should move to the common clock
> > > > framework so that the ISP registers the clock and the
> > > > sensor driver can then use it. AFAIR Laurent has done
> > > > some work on that.
> > >=20
> > > Yes. I hope to get the patches in v3.10.
> >=20
> > Cool! :)
>=20
> The patches have been posted to the linux-media mailing list.
> If the dependencies make it to v3.10 the OMAP3 ISP patches
> should get there too.
>=20
> > > > The peculiar detail of the rx51 is that there's a switch
> > > > on the camera CCP2 bus that selects either sensor
> > > > (primary or secondary). Both sensors are connected to
> > > > the same receiver. That isn't properly modelled
> > > > currently at all, so that's why we have
> > > > rx51_camera_set_xshutdown(). I guess it'd still work if
> > > > you only power (i.e. open) either of the devices at a
> > > > time, though.
> > >=20
> > > Have you thought about how we could model that ?
> >=20
> > Well, the two dependent gpios could be modelled as two
> > independent ones ( for sensor drivers), but setting the
> > state of those gpios could fail, gpio_set_value() still
> > returns void. This isn't pretty perhaps but as a result the
> > initialisation of the secondary sensor to be powered up at
> > the same time will fail since it's in reset: the xshutdown
> > of both sensors is controlled by the same gpio as is the
> > mux (AFAIR).
> >=20
> > So one N900 camera specific gpio driver would be needed.
> > It'd be a very simple driver. What do you think?
>=20
> I think I'll need to see how the GPIOs are wired up on the
> board.

Hello, after months, what is state of drivers now?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2043704.XG09jN2rnN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIqPIYACgkQi/DJPQPkQ1Jb4wCggGuksPYv0s3ZP+KtRWYCF/sG
hSoAoJa6Fk4pZj8pK4mhcyf2iggHO4La
=eBTh
-----END PGP SIGNATURE-----

--nextPart2043704.XG09jN2rnN--
