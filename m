Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3DVOar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:30:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49875 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3DVOan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:43 -0400
Date: Mon, 22 Apr 2013 17:30:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv2 1/5] driver: tty: serial: Move "uart_console" def to
 core header file.
Message-ID: <20130422143010.GA7508@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
 <1366638237-6880-2-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1366638237-6880-2-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2013 at 07:13:53PM +0530, Sourav Poddar wrote:
> Move "uart_console" definition to serial core header file, so that it can=
 be
> used by serial drivers.
> Get rid of the uart_console defintion from mpc52xx_uart driver.
>=20
>=20
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rajendra nayak <rnayak@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

looks alright

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdUlyAAoJEIaOsuA1yqRESEsP/30PjrZ0cfRwE0stjnBoOQNn
gv+w/J8SFrInpDlFhs9OrC4uLSSZUNb1st76Idnyajz6hmxbFvLj5rvN91dMNU9r
Lq1tjGETxjDYIRR3UlQEB+H098OO5Ta3CvMdie/fq5xguekPQIxtvoBwYNx0UtPh
5VaW43IOrEhaUQw52jcgIRma860GD8/5h0G/Kdv1y/SK4Nw+se1YoSKUZwE7zlNU
ZALPERo+kPymf0zswpKi2AkRafKYF6eEfzFqogVwPHHB9mE3x1zPUM8yMbxH5NDM
282ouvDRd0ZA7gqz0H5RnINYq8S3NPUYYWXuzVp+NGFyX9FE4D2NAHAevLcVDopF
3uwqMNvirt63g0aSZPf5TFoxODCYPGFx43CfwJkX3KLf5kB4D3Eq5zJmla0KEIE1
D0AH4Vk/z3/YEmCE8coiSuDDigz9mLeifF+WbeTKhrAHWuMBs6ixPN5smKw9kQFH
ViPNfV3Uge3/DbbtGRmEvcrsz2570Qz59l4QQ4BK3qXqff7jQ5NBgla3KQ6WwOpy
RZpMXIXWXsVexsbk9Yg3aUY1tgNu0NXXtca+IJMHRa2jJdp2Z44lhSs8CQHtn/wQ
yIO7Qo/UMx0LntDbO+iAiW53rsUegBP6Po5/l5raQ5AMBNKyRC8y9o/vMzI0/n9J
xdCtps2hsIWht+arz4ko
=xpms
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
