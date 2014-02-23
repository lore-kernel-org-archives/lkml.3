Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaBWD1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 22:27:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49857 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaBWD13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 22:27:29 -0500
Date: Sun, 23 Feb 2014 12:27:18 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Message-ID: <20140223032718.GY25940@sirena.org.uk>
References: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HKe5j6ME4JFNTkrH"
Content-Disposition: inline
In-Reply-To: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.159.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] spi: rspi: List full example compatible properties
 in bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HKe5j6ME4JFNTkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2014 at 05:29:15PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> List full example compatible properties with soctypes instead of just the
> soctypes, so checkpatch can validate DTSes.

Applied all, thanks.

--HKe5j6ME4JFNTkrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCWqSAAoJELSic+t+oim9C10P/26AmqJ133+5XNAdf8pWxaM6
52kLgNdeTUFFSag5gFDk5yqx7ENMjUXOh5Nb6wBMNJwv+tv7XZk9T0K7k3CZBEAE
hrMQeTeBp02cwO8c2AlD/99OpLiJdNCmtlTHCFdu3f7S6mahn+TDX5SdFPO4CSY8
S5mjoOYL2A7FZVBPeTvlamyhEh7/gj4g5dOvP0tjLMh+7ndMIZbUd+x9ReRQT503
jk82lldIS1d0bY1pwA5glSWNrEujUwp5gHwz7TrCiAGJZUdbuYfXzeiu8Xgz8Q7m
2vcYdqEBBdf3o3kf74AphpOk3f1tndI89LhboaoxSuynh6SPwD11EAcooxPQLkFS
HAm8V1m2PXAxw/V3Tj7XJPZNWtVjqhwsvZgju+1HFe3ohMwtPQdKDk6ZO3om2CBu
JFebF2/UwUlMNrtE3i9t7DKfWz+ciR1VAKWRoR8svqVTrretR/4nUGYwtXfPn86/
KT7ylEmNKLbfEVNC2VTeUhHt7n6+Chr1eYP8mBlO7zAKOnGfAgoonKsPRcuvLGq9
zyU80u+N2D1it9BeDoRvDxY4T+ALwwyb+vl4kVtoVIQ1Ss0wIKAiX0M6rvyPwLuX
m1z8iyNHJr2f3hGXBvGumjofY2XjC3EsaIESGBUMxyIx9N7bgwAnpw85XKgHfy31
Q77pqdOOS+DLWgHjlFfJ
=uqsm
-----END PGP SIGNATURE-----

--HKe5j6ME4JFNTkrH--
