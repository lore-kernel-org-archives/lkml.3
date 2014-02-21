Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaBUQOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:14:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36731 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbaBUQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:14:10 -0500
Date: Fri, 21 Feb 2014 10:12:46 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Simek <monstr@monstr.eu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        <devicetree@vger.kernel.org>
Subject: SPDX-License-Identifier (was: Re: [PATCH RFC] usb: gadget: Add
 xilinx axi usb2 device support)
Message-ID: <20140221161246.GM31902@saruman.home>
Reply-To: <balbi@ti.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <5306F458.9010706@monstr.eu>
 <20140221160442.GA17506@kroah.com>
 <5307790A.4050806@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z+AhoeLdLI498vdY"
Content-Disposition: inline
In-Reply-To: <5307790A.4050806@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--z+AhoeLdLI498vdY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2014 at 05:04:26PM +0100, Michal Simek wrote:
> On 02/21/2014 05:04 PM, Greg Kroah-Hartman wrote:
> > On Fri, Feb 21, 2014 at 07:38:16AM +0100, Michal Simek wrote:
> >> BTW: u-boot started to use SPDX-License-Identifier
> >> which will be nice to start to use.
> >=20
> > I agree, feel free to start sending patches to use this type of
> > identifier for drivers.
>=20
> But we probably need to add that Licenses to one location.
> Documentation/Licenses?

Just add to the drivers themselves, just like u-boot is doing. A simple:

	$ git grep -e SPDX-License-Identifier

will tell you filename and license. Or did I misunderstand your question ?

--=20
balbi

--z+AhoeLdLI498vdY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTB3r+AAoJEIaOsuA1yqRE+AcQAKsHZoO7xg3DVLjmtTTROxju
5mvA5RhmmjsUkIFegUYbbtaFAi2q5QJvZ6pIB0LUZgkRzk+EAPVX7o0+lZWP4ld9
r+UUJRytMqwgr2xq5tLDZdq68iEkzkWfia2VOmHbV91dG2upU9VGyDojzbk7v4jX
5tqnuWfR/bcV9FZwOsT6EjDktNtDyooqlbDQm8q/zGLKHYtu/HlDbHssad0CNZdf
DrrJ0ulczLFBQdlQKNNoNdNYCj0p9/e2vZHEUpBud25CAiAtpw5mYpx4LAqqcxMG
xyqR+EWroEBuq+/Co8UIj8IZaprsG69Z5fyfhMYZMuJVNeMPJxjZcTuAA2inW1J5
0t/t5izo7JRVPD1LzyM84KPJTIBnAHBQgSzMGXm2sd96bhOGgEdvZ1EYfNMCBCwH
q7hZeK4qDwE9g8Wby4xzYpOKoMFDQRPo4mv83c7nLq/u+OGlF52clokirHK9K5F4
zDUPLOJAQdtp2eUVHxUMQuSGzoRZTUVBXO78iBWikcR1TeXcVypCrVpGhWxfU9M1
iFQocndj4sDZVNCUA9Ac7gRIDohBdYGu5cs5HN0tb1xFLFEITmkYHgjvjhRBbuOr
ul4z7ramB735g/ec2y4OchwTh7EzQDYbBYx9zD6mKwEAWN2pZ+1GXby1T9p9VbsL
/2UuuqedSNlu+TvW5w1o
=lcLh
-----END PGP SIGNATURE-----

--z+AhoeLdLI498vdY--
