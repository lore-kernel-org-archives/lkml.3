Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaCXOZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:25:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37743 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249AbaCXOZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:25:02 -0400
Date: Thu, 20 Mar 2014 10:47:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: david.lanzendoerfer@o2s.ch, devicetree@vger.kernel.org,
        ulf.hansson@linaro.org, laurent.pinchart+renesas@ideasonboard.com,
        mturquette@linaro.org, gmbnomis@gmail.com, hdegoede@redhat.com,
        emilio@elopez.com.ar, linux-mmc@vger.kernel.org, chris@printf.net,
        linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
        linux-sunxi@googlegroups.com, tj@kernel.org, g.liakhovetski@gmx.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/8] clk: sunxi: factors: automatic reparenting support
Message-ID: <20140320094717.GL27873@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100215.15040.63745.stgit@pagira.o2s.ch>
 <20140218140516.GG3142@lukather>
 <20140319233945.21989.12073@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n5G3y24fV3/VEqbx"
Content-Disposition: inline
In-Reply-To: <20140319233945.21989.12073@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n5G3y24fV3/VEqbx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 04:39:45PM -0700, Mike Turquette wrote:
> Quoting Maxime Ripard (2014-02-18 06:05:16)
> > On Mon, Feb 17, 2014 at 11:02:15AM +0100, David Lanzend=F6rfer wrote:
> > > From: Emilio L=F3pez <emilio@elopez.com.ar>
> > >=20
> > > This commit implements .determine_rate, so that our factor clocks can=
 be
> > > reparented when needed.
> > >=20
> > > Signed-off-by: Emilio L=F3pez <emilio@elopez.com.ar>
> >=20
> > Your signed-off-by is missing here.
> >=20
> > Once you added it, you can add my Acked-by
>=20
> Yes the patch looks good to me as well. Am I correct in thinking that it
> is independent of the MMC clock phase discussion? If it is resubmitted
> with a proper SoB then I can pick it.

Yes, it's completely independant of the MMC phase stuff.

Emilio, or David, could you resend it?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--n5G3y24fV3/VEqbx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTKrklAAoJEBx+YmzsjxAgy/gP/21KggiKLJZbO5WGulCJ+yRI
bQ1WFh08X8ExEko9bvU2PlA90B6XS9ed4+kAmvncIXbTxBelAE7UqyIEyCcXkfPR
pdZG0TQeZTMvNpK+Ml2G/Ulz4iw0jZ0iTj6RBajh9LjX/LPVlxYYJCfH1H0xkGPm
zXoKlRe0lFu7YFSmuy7qP4YSf6MSmO4YeRlcJOyCXX7f40w6CJsmBEfj52Wa9lAo
95fDz1ZhgbFpGHvbBF18q9J8zgZ0gpYH/D2OoSP0wgNAwxnJIz5QFyokYk94+uZh
WwwsiuIvTdcrnKEy/CQ+biPNhxhWxPVkjM0xhOeH3Dyqqz7NbSfh21RnFsx32WZZ
Z01OONj+izIhOO/sRCq/VXGNXdwQ7x+QWDmjs+u25//HnMLKU/V9kcts2+as0/H8
wNyMmHQO8CXYfl7wFD+FWJETjcXf3++Qhzyomldt0CiGqAZLMAj5RaE0LJ9Jh24r
jwXZrXPx+CszVPe2OGZFcLSWEhi48Qwo7dfakKhCYI/bdfy6BQbwW5StrDHuc+jf
RA0hhLbRX2vHXH/uRYa3BV1BHm+qoqFDObUg50vJbqblQluzfOzUAPAAcCK79thX
LnM54cmbSnVeA+ZakWMBPUM2Y9RQcds/HQ+s/sZAb0Z7Zi8jPkP7mdI3ITuypbfy
K1aMmwOJsrUemyWsSEEp
=1gCp
-----END PGP SIGNATURE-----

--n5G3y24fV3/VEqbx--
