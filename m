Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaIOQqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:46:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43036 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaIOQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:46:16 -0400
Date: Mon, 15 Sep 2014 09:45:50 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140915164550.GV7960@sirena.org.uk>
References: <1410570281-23681-1-git-send-email-jay.xu@rock-chips.com>
 <1410665999-16718-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kUw25p3LpPv7dNi6"
Content-Disposition: inline
In-Reply-To: <1410665999-16718-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: rockchip-i2s: dt: fix an error in the example
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kUw25p3LpPv7dNi6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 14, 2014 at 11:39:59AM +0800, Jianqun wrote:
> Reference to RK3288 TRM, fix an error in the example by swap "tx" and "rx=
".
>=20
> Table 10-1 DMAC_BUS Request Mapping Table
> Req number	Source	Polarity
> 0		I2S tx	High level
> 1		I2S rx	High level
>=20
> Tested on RK3288 board.
>=20
> Signed-off-by: Jianqun <jay.xu@rock-chips.com>
> ---
> change since v1:
> - modify patch's changelog as Mark's suggestion

No, the patch has already been applied.  Once a patch has been applied
don't resend it, it can't be re-applied.  In this case the advice about
the changelog was something you should bear in mind for future
changelogs.

--kUw25p3LpPv7dNi6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFxe+AAoJECTWi3JdVIfQHBsH/0Bd3gC6FkXjlEGXhp28nNCE
x0nmOypVyGISktCZ2gCe/3f5TFsNh6le9oRQBI+PJjeoNG0E87gD4OBAmHDZcUOn
tfi2maUwoc4/5YWLqWTnxkoftppHh+Xqpwj05nnJfBAXu+yZ6sGsQbX2YpsAcHRW
rGWroauzL4W6R5DZdADoIfKeFiv+DaTC6lb/J6KITuxQCiikz+vtaIk3v8GJ9bNl
5pvgqVUlKBW1O9AL/bWCkKdEkpjzpcIpHxkYdJKKeA5SDj0aAto0lKp311lkwcAK
tW4Gp2o+G4hDVN0Gv7tZuEuglzz1TWPAZ+99GeSRl8kXRkkUiGKzzG6FwLjQ0aY=
=1Ikx
-----END PGP SIGNATURE-----

--kUw25p3LpPv7dNi6--
