Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaCHWeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 17:34:37 -0500
Received: from sauhun.de ([89.238.76.85]:55873 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaCHWeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 17:34:36 -0500
Date: Sat, 8 Mar 2014 23:34:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH] reset: Add optional resets and stubs
Message-ID: <20140308223428.GA3197@katana>
References: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 03:30:23PM +0100, Philipp Zabel wrote:
> This patch adds device_reset_optional and (devm_)reset_control_get_option=
al
> variants that drivers can use to indicate they can function without contr=
ol
> over the reset line. For those functions, stubs are added so the drivers =
can
> be compiled with CONFIG_RESET_CONTROLLER disabled.
> Also, device_reset is annotated with __must_check. Drivers ignoring the r=
eturn
> value should use device_reset_optional instead.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTG5r0AAoJEBQN5MwUoCm2K/UP/jLEc+qsLjMjpBo845a05nYZ
fIBGZYdf6b5lZJm9UX6Pe0ocCBX/mQXoUZabJfgZB86vmJf6tCAQWOaM20qq0zyC
UZo7N/tinU7KsiYjHAUK9Wc7I4aNGnoAc50ygBRtdiRjgAvUcZLNI0i4477A2VVq
cp5Xy0q0u6+gOHq5r8AzyjyrpFksHOQI5RX4vdIhcfoqazrTYau1QYT+8x3TvYFL
qHjHSHxDNfM3cX+AAj7XueOcU1cyDfT6gLAjODVgygdf6a5xcd8ztp8GWwsqaI4x
WZ5JahHBo6mlrRZ2OQ3imFEiPcUYVQGbhYVZ2BKOdrPa4y6oD6rj3Zg52d7gkYK5
5S7GHlsCzGwgqP7IfaadbywV41Ispi00eYcNjzOqVNpvYbBn32RMRVV+LcODS+pW
dy22JoSx6/kQoeZVnfx27uQqWSOhBcCk+SiDeBacws4oMMfk4tXtUbAOzjl1Khk6
/Z07MTUry/pW7GAoqy2cycriLHyun/twazrfZLNvxMvS5qXGutVrzV4axSdNzlVb
Y/PP0N9dZV0xNVhLJcxN3OTbOkUguWSk+Fe+gELErcrzU5Y6NTHeHuqadUqtoiIO
8qbRS5k3n7d0YEPoDMsE4R4ivVjpF3lgQLGOqlfTMCNo3bFDZo+E6LAwSU4T2hZw
d7b2Zf/y566n7FzSYhid
=clmM
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
