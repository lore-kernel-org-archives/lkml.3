Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3GYNz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:55:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40234 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab3GYNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:55:54 -0400
Date: Thu, 25 Jul 2013 14:55:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130725135547.GG9858@sirena.org.uk>
References: <1624911.6TtmtVmU1T@avalon>
 <1408178.cxAUTUGJc5@avalon>
 <20130725131556.GD9858@sirena.org.uk>
 <1681089.qGWOhLKTTo@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uUx/k6DZwkQRa3B7"
Content-Disposition: inline
In-Reply-To: <1681089.qGWOhLKTTo@avalon>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control
 its IRQ domain ?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uUx/k6DZwkQRa3B7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 03:22:29PM +0200, Laurent Pinchart wrote:
> On Thursday 25 July 2013 14:15:56 Mark Brown wrote:

> > Are the interrupts in a contiguous block in the controller so you can j=
ust
> > pass around the controller and a base number?

> In two of the three SoCs I need to fix they are. I've just realized that =
in=20
> the last one the interrupts are in two contiguous blocks in two different=
=20
> parents. I will thus need at least a list of <parent-phandle base count>.=
 Our=20
> standard interrupt bindings don't seem to support multiple parents, is th=
at=20
> something that we want to fix or should I go for custom bindings ?

It seems reasonable to define the bindings in a generic way in case
other people have the same problem but it's possible I may be missing a
trick regarding how to do this in DT so don't take my word for it.

--uUx/k6DZwkQRa3B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8S5fAAoJELSic+t+oim9A9sP/1h57qU2ePzeQaMKyqfN2u7/
dQZoxBZQ3WKNseiMIwdD33YgEVvAP42HsSBwZnh7h6oF9vPVMWvb13hSkxcuXdfo
ClBE5HgbZ9r89ptE2ppZLEm5q2MDA1ZzZKdAp7SmW/jDLA/FMtYYwfoCG1h3HJhO
gcJeAXyLGjoS3MwEZcVxlTDLuwJfn+Lz4fZLH3sd6TAbM1y3b1tYX4orKMbPniib
dkeFwXvR/csWoIs+GIBfxtzdK9tDc2b1d7pPFDMbl1VivudOd9a+GmarWj1qzED5
eYibFVYqqWRdpSBudlGzIrqhYK7sHio8/T5X1zJqyPUmFoZ1ZQTwqmvdSkjGetke
imF2dmlecaiPuPgCb7jQjt+RpRtaKJacHBBZ5AC3xQzyzF2+zrENNG/HyBsdU+/S
QgoeF3cpuvRUy7rZ2fKZnb1fjxL9HZEyoxARqIt16ehBX/NVR8SW7s+usbkox5lM
OxR0VeHDn/weH1sGbmJNqzmwICYZpGwRa/x7oP9uk3OnuEvGna8L27b+sZzjd3hV
NiNuQ7Sl0FecCBcMgjOaJU8ZofowHaGSJEqFb7JumPB7+QWTY94KhkWGcjSc1WZp
xrCF4X6PFTR5GQoNUVZ1W9S8WvZTDlxAJDZ952LdXZmFyDUfGlt8bZIxnMvz5hTy
SKjh2F+ffYv8JWbCGV5s
=KyOR
-----END PGP SIGNATURE-----

--uUx/k6DZwkQRa3B7--
