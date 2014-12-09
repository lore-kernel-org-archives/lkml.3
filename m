Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaLIQSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:18:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53332 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaLIQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:18:30 -0500
Date: Tue, 9 Dec 2014 16:18:12 +0000
From: Mark Brown <broonie@kernel.org>
To: weiyj_lk@163.com
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Message-ID: <20141209161812.GM1934@sirena.org.uk>
References: <1418131191-4736-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSyhVCl2eeZHT0Rn"
Content-Disposition: inline
In-Reply-To: <1418131191-4736-1-git-send-email-weiyj_lk@163.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.171.30.28
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] regulator: rk808: Fix sparse non static symbol
 warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KSyhVCl2eeZHT0Rn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 09:19:51PM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fixes the following sparse warnings:

Applied, thanks.

--KSyhVCl2eeZHT0Rn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhyDDAAoJECTWi3JdVIfQ1gkH/2aSF1wX/EmCKytlDl+Cxulb
XbS66CM1q25ypmdMQeERVCkUNrB3LIS2Pte4u6nG+HxYkW8H6buxkeKArqQDo7iU
FsYhH0cNrnRwaEqbePyxfWau95U8FwRPsq4afK3Pfyu1wWh9WFDqbYoWBplBZ7Qw
AexaO4pKzfvCYQ6LnaxPY4/QcsQhEzCw5xaSyto1+RXWxIiXKewBAW+s7sUqBYng
IwCTn8AyIpl+TR7ToVLD6XRUwJaj/qhMTzF5FI8nPF1lRRpej3HRdn6D4sc+Kh9l
9+OLqdCvjLZ4xP8d7M+ClVz2m8QWWTHY3Tv0ZXFatNbuggBhNPq6CdT/eg7nCQc=
=efDN
-----END PGP SIGNATURE-----

--KSyhVCl2eeZHT0Rn--
