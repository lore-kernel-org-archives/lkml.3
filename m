Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaDYOOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:14:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45126 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaDYONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:13:31 -0400
Date: Fri, 25 Apr 2014 15:11:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20140425141152.GN12304@sirena.org.uk>
References: <20140422195117.GG12304@sirena.org.uk>
 <535A60FF.4000806@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7rtRVl0c8BaOhjic"
Content-Disposition: inline
In-Reply-To: <535A60FF.4000806@samsung.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 01/13] Documentation: add extcon devicetree bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7rtRVl0c8BaOhjic
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 25, 2014 at 03:19:59PM +0200, Robert Baldyga wrote:
> On 04/22/2014 09:51 PM, Mark Brown wrote:

> >>  .../devicetree/bindings/extcon/extcon-adc-jack.txt |   60 +++++++++++++++++++
> >>  .../devicetree/bindings/extcon/extcon-arizona.txt  |   47 +++++++++++++++
> >>  .../devicetree/bindings/extcon/extcon-bindings.txt |   36 +++++++++++
> >>  .../devicetree/bindings/extcon/extcon-gpio.txt     |   63 ++++++++++++++++++++
> >>  .../devicetree/bindings/extcon/extcon-max14577.txt |   49 +++++++++++++++
> >>  .../devicetree/bindings/extcon/extcon-max77693.txt |   56 +++++++++++++++++
> >>  .../devicetree/bindings/extcon/extcon-max8997.txt  |   49 +++++++++++++++
> >>  .../devicetree/bindings/extcon/extcon-palmas.txt   |   37 ++++++++++--

> > This is creating device tree bindings for MFD components as devices when
> > those MFD components aren't well isolated from the rest of the device.
> > If we need to add extcon bindings the device should have the flexibility
> > to decide where to add the properties, and really things should be set
> > up so there's less duplication in the documentation.

> Those components has their own addresses on i2c bus, so they are,
> technically, separate devices, and they can (should?) be described by
> separate nodes. And I think it doesn't matter if they are grouped in one
> chip.

That's definitely not true for the arizona devices, I haven't
specifically checked for any of the others.  It's all one device and the
isolation isn't particularly solid.

--7rtRVl0c8BaOhjic
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWm0lAAoJELSic+t+oim9rOwP/0l7mLXKpdC7+yBteXfwE57V
yt7BifQyiA62MsrexOSCDp4TQ7HqnmEHLPScjEXkxuUCg5bXZgxI0Gdaa0/2vB7J
g2pIBKf5jWUGS2hHNr42B5pYZh3DUhtl+uYEnU20B/XRzbm6Hpeb1QFIxgYTKLf4
kiKztazR0eWZnD4YZB0H2CIc3ge0MV7zNB1JDK56w5HgSB8cRAHvVgssUA0sWImo
YOWcuFiN2RjvH3LIHNIO8ijj5BGBYdTFF4kiIeTnsI0QXoG4OSMF3jKXOjRTzjx0
QEbbcHulTh8moD9o9cVWAMGg5CT+HRWEvLPk8XcXV6kr9hT6MBlujhDrXuGkrQsJ
xwcflny1dBsBt151gpRyBEuPYLKWqnx4HtQ8P12K8LMIiAyeV5VFzcsqksdackOT
acVy6VJDphOCQLFlv7+UKMo8t/bcvJNcZ9unV+kUnlecZHqE+EXaC6Z1zA6Ht9YQ
+wozelPJEpuOTMYX1VLr3BKEruEs/h8d+umwJ58RUI0yxY1hxYnO50dCAhE/AFg+
j4lEAy6WqYFP3ILCAtW4kQx0iR9aQV9v85jRpg9gDYKPZM3ZNWPqGPQJybgjDEZO
Fu4PugVPrEzaYwY4VysGYk6IasEiWnRnVpL3c/IG6gDptcyQO+8oYArxePdZZ5vG
uyveuA3Y8FhHOFh7QSec
=f60H
-----END PGP SIGNATURE-----

--7rtRVl0c8BaOhjic--
