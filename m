Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3BDKmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:42:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab3BDKmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:42:51 -0500
Date: Mon, 4 Feb 2013 10:42:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: debugfs: Fix compiler warning
Message-ID: <20130204104248.GK4720@opensource.wolfsonmicro.com>
References: <510D98D1.2000008@semaphore.gr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1y1tiN5hVw5cPBDe"
Content-Disposition: inline
In-Reply-To: <510D98D1.2000008@semaphore.gr>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1y1tiN5hVw5cPBDe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2013 at 12:53:05AM +0200, Stratos Karafotis wrote:
> This patch fixes the following compiler warning of uninitialized
> variable:
>=20
> drivers/base/regmap/regmap-debugfs.c: In function =E2=80=98regmap_read_de=
bugfs=E2=80=99:
> drivers/base/regmap/regmap-debugfs.c:180:9: warning: =E2=80=98ret=E2=80=
=99 may be used
> uninitialized in this function [-Wmaybe-uninitialized]

This isn't present in current code.

--1y1tiN5hVw5cPBDe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD5ChAAoJELSic+t+oim9FRwP/1JtjVw+RcT6TRJoY8sBB+Hy
9Jy2HLpiIfWlwDr2JzmBRaYCSIT7PLa1N0NI3Cu4ulqxqGWPLybF0OucGLiLR0Ay
9Ybygm+qCzzaTuoYCv1Ht2uvq5rFCmh9b307bpIrP1nQjDUStcdtLSB104WiIuJB
mkbwFUgBPV897z+K+ua57r6tx+EHvcEZggh7W2sPtgPBNqn69ZZAbtP5kSvx1UQ/
NfZl9JyTMgNnMdTjLV+gxOSznCZhMIvwb8nAYi2BSXnGtuy2BkOtLSfp4RUq/W9a
pI0paTRpuBrBe0vUQV5M8GEbEQx/3XtEbWlkzbOshA8XgIeU1xR5hY1BTsZ5Wdgd
501uQlQ2U1J6lREY/yRH1fNFl8phQw8fGxwBVrflUh1dDB7QSNjpuQc0DSYX1ltg
XIcllRqgGDdvy11PXG9LU/ROI78VDFQALtkuRzID31qqxtnmlLtgk4x0smHevBi7
MVBwMkc1gvAAAh68+FbYjJVlBLUgippGzuewaNGT3iNFv+pOkmRUfHBxX7LRV3tQ
dzvj3VbujklS92CSFR68Zwyoou/nacgCOiTaVE5pQClfPwtF0BUhSJkhFr9SnNA0
Y6OXciAHMKSnqo5VIK2i1xf9lJqwX5lLt+zi+7vQ+eCwgzCzvoSnT5mzrCpOdZSF
qa1P0i6IYetgccMBgWrf
=Gk3m
-----END PGP SIGNATURE-----

--1y1tiN5hVw5cPBDe--
