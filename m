Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaDKNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:11:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755577AbaDKNKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:10:10 -0400
Date: Fri, 11 Apr 2014 15:07:02 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 6/7] pinctrl: sunxi: add reset control support
Message-ID: <20140411130702.GZ28585@lukather>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397137966-30818-7-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m3EZO/+NOdcYnaJL"
Content-Disposition: inline
In-Reply-To: <1397137966-30818-7-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m3EZO/+NOdcYnaJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 10, 2014 at 03:52:45PM +0200, Boris BREZILLON wrote:
> The A31 SoC define a reset line for the R_PIO block which needs to be
> deasserted.
>=20
> Try to retrieve a reset control and deassert if one was found.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--m3EZO/+NOdcYnaJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTR+j2AAoJEBx+YmzsjxAgTCYQAKyO8v3wiGvJy5ViwLlmu3Hb
PCpSFCuVYfsto5JX6zpqql1J2OL7BrVe0DZJtIgNHHmC5BLmz52+9tNU+XKtjKag
a3HuFrnPMzDpriTMmlR/cPRHxcRsgo3F8oLk15RF4zeJXNJvpqECN3kXVYxCi5ns
U9vdOOuwh+IadfejtqgRaqE7mz5Ta262KbQ09WGXdFoJsCuA+LyaO/fPuGWhEOti
1vNYuEj8kxdxv1inIRQiMmqRejIxifo3fAwQZDTVEQq0wcZbhLSZYWrBKuC8idm/
8hXh09e0h3z1PLPGEppohCttHn4GDRJ5uwYw+pYK4Pfl/1VHEzxOZPrzaMhILn2/
Pb8NoWJ54VrDHvrOO2s1GI3U2uT2g/Ut+LOpkQKc5/ddOgP8jVIpKzm7Bk1bxu6K
iSLXssbPrGtXIhoikkskbNf9Wx0cxVgIzmpGXTN9ELjQMdZh9/ue/tc1hDB8mn2V
N/XUrOfcRmt1XGVLaWkXgMwP8m6fwOuZgLnQ+WaZotCu25hPRdy+mvwN3R+raY0J
FASpNynOCa8jlWv+DoxPVoN8gnikf5dmJTUwdkCdvyLz2+Dioq6DrCEaT48kOaL6
rlde3qksl/Un9ZUYeCdJkiU7f4sGF9bKJq0sqT029frr5E3GovBN7TG5ZC2t1ESs
uC5c3BPbVOCxu9JzN/ZP
=05tP
-----END PGP SIGNATURE-----

--m3EZO/+NOdcYnaJL--
