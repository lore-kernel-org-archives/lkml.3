Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161044AbaDPNKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:10:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48138 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756276AbaDPNKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:10:06 -0400
Date: Wed, 16 Apr 2014 15:07:21 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: sunxi: fix typo in module author address
Message-ID: <20140416130721.GL3207@lukather>
References: <1397653068-21788-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5VuzLDXibKSJvVYD"
Content-Disposition: inline
In-Reply-To: <1397653068-21788-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5VuzLDXibKSJvVYD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2014 at 02:57:48PM +0200, Antoine T=E9nart wrote:
> According to the MODULE_AUTHOR() comments, the author name should be
> "Name <email>" or just "Name". Add the missing '>'.
>=20
> Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5VuzLDXibKSJvVYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTToCIAAoJEBx+YmzsjxAgkwoP/jnCv9t0TW8b/KHKHtZftrVm
oGhxqImBXOxCyILRF8yxePakHPch9tfNY2unlmvgLJRbBZBN+En3YlanrrYgloMc
Utc+8Heixeq/Y0aNe3o9cuQ2xzWyCJ9NmCtjQ/qLtn7ll7gACQmi6E8AjJZlCvib
u0ghGISk+71elcpoaN8NB8p3iO5Ea38uO6k+kc7Q3+ElUUqSLzPGvE97mA9zPv1g
inMquZhR125jbd3Lv+w0syppBqD+2MQ55XJMMTCFa2Q/d71di4PXCE7rRGxZ9Hb2
9CX5pDca9K+cmJTQ0qnRqWyQ2N1cOtZcSCCauRY5vgWE7hkO6qF3I5NuYmlKvs5+
4pWsIbRK6449i1xcH4SWTE9w6JvWshN2v6b8hUzCQPnvKTyR0dkOdMry/EFBbcnA
lOw837/eIjFTrAP5kliyyyrlCKc8FgSEkhGrPFSX8e+0Y/k2WGbMar3YwGcsoCp+
tshEOkZBFoQC5nMi1UbpkLVOTAAbizWEDsKq3naKAJXTcnl97R0KHrUkH3w/UgVd
Wilfjz/hMzf6uTkBHVpzJ4nWy/glQgsKGg1whUqnFCP84LcraDVORyA+tAZ75Zd5
uR+yYa39iQPZnuPPBuhxow82kta58GvJR/RXsvJuq0sFxaBXWHYsz3Jprdj3o5e2
sHgh7NKprvoDX9ycYYGu
=MD8A
-----END PGP SIGNATURE-----

--5VuzLDXibKSJvVYD--
