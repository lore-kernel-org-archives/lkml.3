Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab3GRKol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:44:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52907 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3GRKoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:44:39 -0400
Date: Thu, 18 Jul 2013 11:44:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        balbi@ti.com, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718104414.GH22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-4-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yBTt7CTH+yMq4SuJ"
Content-Disposition: inline
In-Reply-To: <1374141687-10790-4-git-send-email-sourav.poddar@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC/PATCHv2 3/3] driver: spi: Add quad spi read support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yBTt7CTH+yMq4SuJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 03:31:27PM +0530, Sourav Poddar wrote:
> Since, qspi controller uses quad read.
>=20
> Configuring the command register, if the transfer of data needs
> dual or quad lines.
>=20
> This patch has been done on top of the following patch[1], which is just =
the=20
> basic idea of adding dual/quad support in spi framework. =20
> $subject patch will undergo changes as the parent patch goes[1]
>=20
> [1]: http://comments.gmane.org/gmane.linux.kernel.spi.devel/14047

Just as with commit IDs you should include a plain text description of
anything you link to so that people reading your e-mail can tell what
you're talking about without going on line.

--yBTt7CTH+yMq4SuJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR58b7AAoJELSic+t+oim9jwMP/Asz1edR2cgkUy0hsKMh8dr4
wibv6McCcJrnEy3f4CawpiuJ7QQC2I1hS1S+zn45eTaiI4SWibxKWKLp3INnY8k4
gvnEmlbSaggRpDPdsyS6nnOpFeGOpmlcJWgqjbIkPCMIUsh5zAYN4W3G2aOLI5se
blz7lpn9+L7zmFe8VeO1GtWl1QGngRdni/U0/d5iA9Qz+5aiZ3djwzKF1Nk9dO5v
dghJnsP/rA5ll+sXMgGd0U07bmeVG4deicwdpPqiST2SK+MTx5TgU+/K3RVfs0h8
YH5PVcPVjYYnRQUiO2cHvSwl2XWE4Yqbzp26cYsNK80kD2wAPUM/5Z2/MCFwKsoK
oR/lzuvKjFu2lIxY/HVORTSaqZgttIDQRyB753//xqoQ6kXQnX5LQ19cyNHExGM3
3kDUMICXZqvn5koBo1HWfg4U4ZThi/RUm+wA/s+bXaY/7HRXc5CtoZWLD7J2vnhn
FYcRnx9sqtLRM5fdn1F+i2+sqWVaFzm5kSXBKSrT+iWtJV4SnGlfRlwRVA6baZuE
fQL1m4qs7xBNjC9JKavlId2F6xDd9v/Tb/HdIyj5RFNhP9FMZ2X7tzfwwu3YrYvy
cySGwOGXJOgFFKWXriuda6DqbT9tt5SwzCCV3/dvpZuLYaTEEq7rB7nSZZ1HlQKu
ZeGMkRl2FftAlPrLzOzW
=Nt+Z
-----END PGP SIGNATURE-----

--yBTt7CTH+yMq4SuJ--
