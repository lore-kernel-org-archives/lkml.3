Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3HPFrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:47:41 -0400
Received: from ozlabs.org ([203.10.76.45]:42286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab3HPFrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:47:39 -0400
Date: Fri, 16 Aug 2013 15:47:33 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
Message-ID: <20130816054732.GA28445@thor.bakeyournoodle.com>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <520C9A39.3030808@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <520C9A39.3030808@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 02:07:05AM -0700, Guenter Roeck wrote:
> Hi Tony,
>=20
> would it be possible to provide an arm64 cross-compiler on https://www.ke=
rnel.org/pub/tools/crosstool/ ?

I have one built I just need to upload it.  I'll try and do it this
weekend.

> Also, the xtensa compiler fails for me with an odd error message on one o=
f my servers.
> Have you heard about any problems with it from others ?

Nope.  Sorry, but it looks like you're being looked after there.

> c6x is supposed to be supported by gcc now. No idea if that helps anythin=
g, though.

Thanks.  I have tried to build a 4.8.1 cx6 toolchain but It hasn't
worked todate.  I'll keep trying as time permits.
>=20
> Thanks,
> Guenter
>=20

Yours Tony

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBCAAGBQJSDbz0AAoJEEsCiJRY75GKtDAP/1/DMTrYXdr7DBExNIqP4i5C
A+yiwj0K2hOoyYgcTOIOVOSuHZP+rdzZMkgDf2AwpiBm7dWAfLH5LqZafGX41BmK
uCIdcA5WclK4rJ7mJEaobKVLWJ9ik6K+3a2i9GZCuJBwz9y0Xl2hdkopuQ1UrwZx
VTf1Zj7osb4g4vaDC5TsfdSFGj1WtuNPUtgjLtmov0/En5yaeF26Z5NnBeXY2zvV
4FBMc4uz0uE9IVwmr7A6kD0QU4JYngIvaUNwIAJExBGaw8dQoc0hBVntwapfMJ6H
2Nnw+Bso8T/e3iSr3PM+3Q2Rl+wGyyK7EiuT6rm0kBU/ZsfAfTQz+TaSfDY4qtiu
RcPRhVKBb/+HHelVJ5xbFvydlEYDw68Z8AG2L1xckJe1GG0R9TOhygHgIIaw1p4x
/5/C/FX3HUdwBvS4btATsaO97dGy1R+ujbi0UP1x7wAxkeNYDq1wG1ltSZTopjyE
0pUf9KR7+rrpp3DJcuSrLVz0nC4U3zdyVDh3R9buqEkA3S04NugbLP2joxM2xWTP
uouBnM/yl3bjgOsj0azXXa17XpdgxTFcuCrPij0jscH/N8spdM1AFEaXFpPq2Jm3
Jm0p5KTidNVt0I6N77SCRAP6/upM+eahzOXKizeKSO7lVXWaU3JMZmBD0nTmwmNi
a3uknyA6I1l+DyDYZXgQ
=EtNF
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
