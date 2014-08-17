Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaHQMbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 08:31:46 -0400
Received: from sauhun.de ([89.238.76.85]:42358 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaHQMbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 08:31:45 -0400
Date: Sun, 17 Aug 2014 07:31:33 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Add eplicit dependencies to catch "select"
 misuse
Message-ID: <20140817123132.GA2863@katana>
References: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 17, 2014 at 12:08:57PM +0200, Geert Uytterhoeven wrote:
> Add explicit dependencies for the various regmap modules, so Kconfig
> will print a warning message when another module selects a regmap module
> without fulfilling its dependencies.
>=20
> Without this, it's much more difficult to find out which module did the
> offending select.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8KCkAAoJEBQN5MwUoCm2HeIP/2ZIAC6VYd0ayPPUIQl4JQ1n
+YL4tfff/yGSQGWlfci7sbm0RTvrb4sEPF1vsOc0PuTDlwaZKHvYpgYLf9JvZStb
LqWHI9FF3MgawG45twvM59UifPa48PX949o4zxHQJRcReRWzjDjrkYHImKLGGOUk
kd7XyfmgHFm6k37u8UF9LkLqTZ4mL/4QbRbQzbiOymohqbO4Wsbgai8ZiKtDVAr9
hrNCFB0+ZHSVHpfyKuxR8PRNMzSItec6I2NBvd8pdlyRFHJ2u3FUCJMWQSXQVuev
LqbsNaqeKCOD4Qfxd8yHqmUrNFk3mhzr93JXrmHa++T4OsGU72NZecW2hz8B+UCf
+d6FEggpZWkR6ZNzrzxxTv6/QSJCiXgwxFokoTJuISNwytOdEvfmM/+18Y/EiBdt
77wDswfxl9Mtu6RRITEShwhsRJ5PaPMB6DnCC2qkOHb2mMrcKlIPF5fVgYLQu+HB
HS6C0Cq/AcxUmNj1DQ/Ee/38v0aykIKJjnQFlT4wMu+HQWzDoi7t2Avn8aFVNr50
RMBJjXwX/u+IvtE3ltZNAuInYVdusCxD76MYDpo9ZNv1CbjjOO/QwUzG26dOIgFC
Q6aLWeIciPUx6qBgY54bFKmd+ngBfZ7GfG5mJpCiRb5T+hUvhU0A0lHdWuyhURsZ
ISkYA6xWBn85OQSL925Y
=FsWB
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
