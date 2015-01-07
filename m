Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbbAGReU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:34:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41710 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbAGReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:34:18 -0500
Date: Wed, 7 Jan 2015 17:33:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150107173351.GB2634@sirena.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
 <54AD4511.30702@arm.com>
 <20150107180825.52334d4f@armhf>
 <54AD6A5C.60903@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yTfYsguFsV8cp5cf"
Content-Disposition: inline
In-Reply-To: <54AD6A5C.60903@arm.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yTfYsguFsV8cp5cf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 05:18:20PM +0000, Andrew Jackson wrote:

> I understand your difficulty!  I was just wanting something to clarify th=
e=20
> meaning of the value without reference to the driver source.

> You could add something like this to your existing explanation: "The value
> describes which audio input pins are selected; this varies depending
> on chip type so consult the section on audio port configuration in the=20
> relevant datasheet.". =20

This is commonly done by just saying that the value will be written into
a given bitfield for such and such a purpose and then relying on the
chip documentation for that; it's a more direct way of saying the above.

--yTfYsguFsV8cp5cf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrW3+AAoJECTWi3JdVIfQlX0H/RX+ohGKBgKyWlTMPcFZFEB6
tMppOk1zQhdIqxs4qWJPsRDC2ZXWRXgk2WI621PSjkxWrhAO9H2Jju0G9fnmdynq
5WSZsWe1s1yDjOYMLnbhUIOwWzDqCHYf+bH3CeDzvWPIG+SmujHRnKI6AS/whzPv
jQrGnS7T2u3IV+3IK2TgJohIU9JMdft2KsTk4D4YpXDPS1BatvcitM6UfX/en/U6
SawZUl6NGSzT+efmQWOastopkjn6r0bA6odaGI0DjaXnmq+ymCj9BqOb1Qb0EhSf
0vv5GdPfZYDukvlU2FuLP/iWHNixU7N9h2pcvJsC82/Np85l2Im7VqIBNDWIcQY=
=7iDb
-----END PGP SIGNATURE-----

--yTfYsguFsV8cp5cf--
