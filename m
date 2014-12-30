Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaL3QxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:53:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55965 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaL3QxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:53:04 -0500
Date: Tue, 30 Dec 2014 16:52:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141230165238.GL17800@sirena.org.uk>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
 <c310f40f0b3b3bcd72cb02a7e3963d56f21e9dd5.1419936132.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PhxnRSt5kLYkr28Z"
Content-Disposition: inline
In-Reply-To: <c310f40f0b3b3bcd72cb02a7e3963d56f21e9dd5.1419936132.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 5/6] ASoC: dwc: Add documentation for I2S DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PhxnRSt5kLYkr28Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 10:55:47AM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> Add documentation for Designware I2S hardware block.  The block requires
> one clock (for audio sampling) and DMA channels for receive and transmit.

Applied, thanks.

--PhxnRSt5kLYkr28Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUothVAAoJECTWi3JdVIfQl7sH+wU+zJVnvDCJKj06LlDv+Upo
VhACzba2XfQR35i8lECPpEbEyDLp/jyvBHECtov/TrZrw3VfGbBwgGLTXrMtS4VW
vvPhWg4kfvT6CnorRi2Y0KvEw6MIyOiOoyEIYbS7s/Ien0Po784kHqf2Q/YX55w4
gxxDbYNr2aAHmnDhFb/OeE9SsHV1T5imF81CrC1nlGRPNUVT0S0XxQtSYd597yXC
XhWUqqV1P3I2cmjbFN6BKWrvCu/rtZbrwYAWY8l3Derb/abi0UdGd8PfqCVtnqTO
He1VPnsXhhA6TEvQeCKw4h8Aip7R5i9Nxf9xPTrVuFdK3uVpIyGJrfhdM7RYf8Y=
=OCi0
-----END PGP SIGNATURE-----

--PhxnRSt5kLYkr28Z--
