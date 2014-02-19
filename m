Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaBSNFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:05:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43045 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaBSNFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:05:18 -0500
Date: Wed, 19 Feb 2014 22:05:00 +0900
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        kernel@pengutronix.de
Message-ID: <20140219130500.GS2669@sirena.org.uk>
References: <1391697321-14231-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MgsldsnE3DYXgZCe"
Content-Disposition: inline
In-Reply-To: <1391697321-14231-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9052: Add ramp speed information for the
 DVC regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MgsldsnE3DYXgZCe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 06, 2014 at 03:35:21PM +0100, Philipp Zabel wrote:
> Some LDOs and DCDCs have a fixed ramp speed of 6.25 mV/=B5s. This patch a=
dds
> the set_voltage_time_sel function to let consumers know about this.

Applied, thanks.

--MgsldsnE3DYXgZCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKv5AAoJELSic+t+oim9dj4P/0tNKtfP9E3Vw16VAfDeg6yd
V++Qz0R657X8mqGHPOKEoJTgaad/r+nOkRRQbmMBTK9jAFPfathpXlVEOxagY5RE
8G08GaPBIY+CxxZh9DDY61kk8VjlXUMDQxXqeuhh3a8YBDl4M1Lw5apiWAM+/CyW
Kr3AxypBXSgEir55Ib4ps2K5KQTxJ7iA8bBc4yVAz+wGaMjgdgQ+xMl7AJkhUoKU
t02btiAm+6/0desq8pIeQQgbKUYeM/0P7786kPV/gP2eBhoRpOyo0/5zaLY/3TcB
6/jIGB8LWjAnnlh+T/3PqbGU4+Pi8diRllPzWlq2PUzzWUpO8PKdZmTXGwvfzB1o
4RtsAxz4rY9q0UNQQHTLf0ks2P0eyf9uqItFZdXI7YgNWTtoTHAWOAReSiu/BLKB
cxyO8BhljqZhDwj2w6Oh1hfQGkh2bmT6lj373dbJPGeoVeVx3y2u7dGiaGFTq0fP
o/GItXhP48NYxXzvTsnPn9ELnCWITmO48VrJVm92tR7Fl1EYOoAKGIH0nlJ95k+T
IU/7tFjIhHzE7s2QMOTR2DxcMBjFqz3e70IMov2a2rzZjrCwidmACdnv6AMLEjJ1
scoe/kA4QkD2n04CVcIP9m2WmU29s2FiEQaDt0YFOm20ijVO4r9HW+rvhrjlAaYR
q5EOC8pZWRoGWS3DBPbV
=Qk/z
-----END PGP SIGNATURE-----

--MgsldsnE3DYXgZCe--
