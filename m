Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbbAGRfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:35:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41720 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAGRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:35:06 -0500
Date: Wed, 7 Jan 2015 17:34:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150107173450.GC2634@sirena.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
 <54AD4C77.5000401@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E4bwVoblQmO+UfRy"
Content-Disposition: inline
In-Reply-To: <54AD4C77.5000401@arm.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E4bwVoblQmO+UfRy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 03:10:47PM +0000, Andrew Jackson wrote:
> On 01/07/15 10:51, Jean-Francois Moine wrote:
> > This patch adds a CODEC to the NXP TDA998x HDMI transmitter.
> >=20
> > The CODEC handles both I2S and S/PDIF inputs.

Please delete unneeded context from your messages, it makes it much
easier to find any new content you've added.

--E4bwVoblQmO+UfRy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrW45AAoJECTWi3JdVIfQYOYIAIBRRUG56ED979cEIDEh/gIN
C1/F6sbniZUcLBjliiKVo2rWZ6MZgzMzyNdlwTB5f1VN+0YwuPRn2ac23+cUqdDg
dqVbiGd6wYPEjnqyVC28cBg2x41CnZCcF3Qn7zbMO7q6lIsxH2QHhfl6/kviK1Co
y6PksCAD8bFgq+ux0pXVQCphl+1iMlbDKw2ykAM8iDszuz3mdsk02EmA/rmK1egO
5xbN+Y+nBxB/CWGem6TlseT3xAmXkD31O8ZCn9rauvuwoJKL0nthC6w1WZvo5ASn
PcPd6fWL2hB86nZdsBKc0LKvNjytepgbFWLjjgnDKYZ+dIEKI33j8ILMYc8UdOA=
=+QeS
-----END PGP SIGNATURE-----

--E4bwVoblQmO+UfRy--
