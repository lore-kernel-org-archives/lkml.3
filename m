Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbbA2BZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38391 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbbA2BZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:26 -0500
Date: Wed, 28 Jan 2015 19:25:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: mark.rutland@arm.com, stefan@agner.ch, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, B44548@freescale.com,
        Li.Xiubo@freescale.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Message-ID: <20150128192545.GA12296@sirena.org.uk>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <1422356244-15629-6-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1422356244-15629-6-git-send-email-bhuvanchandra.dv@toradex.com>
X-Cookie: Rubber bands have snappy endings!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/7] spi: spi-fsl-dspi: Remove spi-bitbang
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 04:27:22PM +0530, Bhuvanchandra DV wrote:
> From: Chao Fu <B44548@freescale.com>
>=20
> DSPI module need cs change information in
> a spi transfer. According to cs change, DSPI

Applied, thanks.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTe4AAoJECTWi3JdVIfQEHQH/RdKiPoPotBM0/69lF5IH44z
7AiRC0G611a+DnAkBrQmYHZ+od0qfKEUYF1C1RBfrHXo8qzQWqw6o4aDJS2whh6t
fIeJrIRGMISYoh5I83Jwe39f3IZwGtOtw8igQiqjq1sBzH2YoPD+Szmq2IhSufMB
qf47bJbq2IqlrTK8WK2Ev4d2ear534injn5vycf9DN5/G+yDwkM+t2ACZh3ujBzf
5lslQGYFmm89AZImSA/VnlSjXyUQ2Fm7tRnSWbjfXNRTNnISOdpLE6BNMMWEcWdy
pDnVTHK/zd77xBfFrxfdvWB64J6GWQH6OiPRE9spwriakeQgOzTS0wOQgUlIbBk=
=WP2r
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
