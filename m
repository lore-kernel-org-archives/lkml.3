Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3KQP17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:27:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59400 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3KQP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:27:53 -0500
Date: Sun, 17 Nov 2013 15:27:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lgirdwood@gmail.com, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20131117152721.GA20266@sirena.org.uk>
References: <5288DB85.8060105@hauke-m.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <5288DB85.8060105@hauke-m.de>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.49.214
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: build error with CONFIG_REGMAP=m and CONFIG_REGULATOR=y
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 17, 2013 at 04:06:45PM +0100, Hauke Mehrtens wrote:

> In OpenWrt we are seeing some build errors when CONFIG_REGMAP=m and
> CONFIG_REGULATOR=y are set.

REGMAP is a bool config option, it should not be possible to set it to m.
How have you managed to do that?

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSiOBWAAoJELSic+t+oim9CZIP/1MRQs29QO84zaQZws8F77oy
DukbePsR1qBXVj5Ry2ZO/DS4BXbWUHcXRzPe9uROdSbjwf7a/B7JZKRy48lWxgyl
1be2P/Bp/0wD9ctjSfCVJgaDeceMN/rybql3wImmpKQtpStYvBZHrAlIWzL+piCh
lpbXxidyXsffy+QOkW0d+Zup2lll+ISi9KPvaLE9vwr/w61odJfet8xzQo8WCtlH
7oi7ZsiaWYY7Hptif+kjj1KAqxRMW+OokZ/6MmyEFBj0GU0KO5yx0Dy/Paf8H9C6
5tanf/IZKVL7KVplhOjq2L+A3ETIbNoW8W8XA4AN0YLx89Tsn1Cz49jGORo7AHd4
4uQLtuhFwYRL1RnqHJl7I2nBaQRrwDpTrYwc07DrUDrj+3ORpM56maAZ2UNwurhN
O6SVejlGrTweUOVZWMbjBwLykAvV0rW64/KR1L1hcrFPeCsIyz+ioR426aY5N2Gi
gfpzMvvZ77ofdtYZKzPiGCWJi9f7ZL61bnUP2SN9Hd/+tu+I9pUQSCg+NCqw7Q2g
KJ8RICoxVtzBKdbZL+kKb70QTA/rTI/7cTMwPT9mGRGZ69KrXcpwFbHSgiZdr6dD
SaH3V0BqBwA0LEo6rTk4TU+qH6qAJ30jvoCRnKJFq3Uv+FsFxE8N7B5iM9T663gu
m+d9uTdzaoBdYJBOr/2n
=Mnkr
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
