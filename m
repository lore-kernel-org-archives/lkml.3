Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaEEEUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:20:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35406 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751087AbaEEEUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:20:07 -0400
Date: Sun, 4 May 2014 23:17:21 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
Message-ID: <20140505041721.GD11606@lukather>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
 <CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert

On Fri, May 02, 2014 at 01:28:26AM +0200, Geert Uytterhoeven wrote:
> Hi Maxime,
>=20
> On Fri, May 2, 2014 at 12:36 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > But it actually doesn't work in a case where you can't really predict
> > what is on the other side of the bus. Either because, on the board
> > you're using the pins are exposed and it's pretty much up to the user
> > to know what to put on it. That could be handled by DT overlays
> > though.
> >
> > What never works is where the device on the other side is so generic
> > that you really can't tell what it does. Think of a microcontroller
> > that would behave as a SPI slave. It's behaviour and what it does is
> > pretty much dependant of what we flashed on it, and suddenly the
> > compatible string is not the proper reprensentation anymore.
>=20
> So you will (hopefully soon) use overlay DT to change the DTS to match wh=
at's
> connected?

Not really, because you can't declare a spidev device in the DT.

> And then you want spidev to bind to it. Would it help if DT offered a fea=
ture
> to add a compatible entry to a driver at runtime, cfr.
> /sys/bus/pci/drivers/.../new_id on PCI?

The thing is, in the core SPI bus, devices are only instiated (in the
DT case), by parsing the DT. So, to bind a device to a new driver, it
has to exist in the first place, and it won't exist, because there
won't be any node in the DT for this device. But since DT is
unsuitable for such a device, you go back to where we were initially.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZxDRAAoJEBx+YmzsjxAgsgcQAJmYNBp6yVydJWtoXy3haoEs
GXBtHDoUsFy742n+/+7p2mL/Cop6lWoNbSLxNQYRSUysJFWBPenI6nIAjUvJKzT1
iyhCBqTUGVrdDswllZ/GDfdj9vYqGLEaWDmBxcsfVXf6vk6vaXYPCk4L8+u623Rb
X5SopLZ8Hgsq+ViKykc/f4EYyRZZPtjsgv/vOyRpr0Ys9JfMwmSUptPg3YUo5C2k
7U0SmNE/tAXTWtLRmfy88ZwsW6ASjhlywSjTS3i+eXxSUnzYEO0f2Y8vCoQx6VOw
t2A224eoBoNPkkSMs0GGCOL6eucX6ViwN4+TTDuxyFbdbYTJOvrlOHRZmIwvN+Dp
t57gJuLPNXF8FYjLidt+wqSeLm0t20kK2Tfw6kjNnzQmZoEkRRrCbOpgifI02fzf
OUENW1oLJnS0VNDY1EvxJ7wf1tbb428hMuZrKw5CqfEoigBGRN1CcXbF0TjIOtRi
cTbiM8pUBLbvZS4w+UjNR2JbGfwTOfpRoSukrOAuv4m0AS0ujtrUBQgktkEOotMD
2dnpgH+kBpYajDrAF2zcLq81lSzEB4NrPJY9JsO7Ng+JVG9LA1nFzFNQu3R/we6B
+p8n8D4qg45kw9Lr4JwKL99Li5G262SyB6PbTFjoPE6u/qdtDx38JxrwoL1PImKN
hz96hVQ3jRzeRFhV7ZNS
=+HCa
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
