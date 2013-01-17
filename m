Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3AQP7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:59:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab3AQP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:59:19 -0500
Date: Thu, 17 Jan 2013 16:59:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Philip Avinash <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, nsekhar@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH v2 2/2] pwm: pwm-tiecap: Low power sleep support
Message-ID: <20130117155914.GB2186@avionic-0098.adnet.avionic-design.de>
References: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
 <1358414403-13431-3-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <1358414403-13431-3-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:z3sRNFR5z2o87RFzEuLt89N050MDgsmHlYnAoJ/yNqb
 vlO0Kl+5GK9nwL+47kvSlseS1vSgUIFoC33ANX73waHf7tXoZs
 5MyWF0ZCrAu/yqj3hW+1rnwVeCNsuFjt9UhphDxzBXKzY3+t80
 /x9MNw8L7sdieLKyjpJJ0c+jsFwT8ITACfQlGiMQGHpK4CBTVy
 hHRzVU6wn5kIxV6r2ksTgkZJpLscSARW0b7IiIncHOfZpqbV0k
 vuDFRQ68SCN673lhV0SR9tNbxufahjJYWmoXWXMNRZqpNOj81+
 CpKzdZWc1dCaKo5+KGlSccqYTb2+4rIJdz/D3ih1aU/GOrBBB+
 9jfXGQ/RGAWRRg5g1Kcj0x8FE3bva/TPb54hUs27V4UQg6gznQ
 PJ0V8YvEJSFUIj6v1/Jv4n4zqEBXeH5yak=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 02:50:03PM +0530, Philip Avinash wrote:
> In low power modes of AM33XX platforms, peripherals power is cut off.
> This patch supports low power sleep transition support for ECAP driver.
>=20
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	- check the enabled status of pwm device for handling module
> 	  enable/disable on resume/suspend
>=20
>  drivers/pwm/pwm-tiecap.c |   53 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 53 insertions(+)

Applied, thanks.

Thierry

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+B/SAAoJEN0jrNd/PrOhgB0P/1KtbYXQ/MiniNN1fdlKePgT
F1onmJaOt/Nq3FOPirxMHrNYwpPSDhQ9O4mur9fNE1HcWUUUuwynfqjoitOJdIsn
45H0zLQ9N38QL1dJ7VYRkEQTY7fQfqiij061Qkv1wIS8Pg7cRuUyWPfmUhFWtJDX
H2mOFyoGf+grEzxuIB8iU9EEAqwUkun3eH9WvPhbw6w4xe/gootG2TIFrmPr8/rx
tIHiSwqgoKMdUMtF/NOdFkTFBaHSGv95iPyiPjpxa08iD/mUmpRBycgFkiVHWhcF
JBSFegWlC3+wAZZR4iqxDtKrX1WT6TEMwpqylCRQYjxkrP/l+PJWP/rnPCJhm9h3
SiWPN43NGWNijsPTtc76zmnwl3YZXCEauQtXNBtGg/RRkDH9rhCdwn8c/FwiNg72
c60tl+XkESg30UBG7wP2qCs7s7s6pvJP4v2VV3aNhv1p3VCTGyc7NZ5zImJwixqr
CgWDaC3iRAcr1ZvFNusUXhang73nvif38cXIvVhNRc55Oumj8Z1BnqbyEnRrCv5q
xiz/LzmeYExFfW7WoLsW9jFOKPtuWNNzzXiVpVS1Xawkv1Yt/tgXouWwV+KNSxGE
yM3UqreCf9g95qnKvPP2KGX7VKkylKOsBJ3CYy2jJDPP9WrMD5gf/X9KM10CNYBz
cmnO9C8N2T1NmZt49JT2
=f2hJ
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
