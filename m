Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaBLPuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:50:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40864 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaBLPuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:50:19 -0500
Date: Wed, 12 Feb 2014 15:48:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140212154847.GX28112@sirena.org.uk>
References: <2573561.oCYNnnL0gm@phil>
 <2409422.L9c2tQTy2E@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t4k3FX2BKM3OLyzG"
Content-Disposition: inline
In-Reply-To: <2409422.L9c2tQTy2E@phil>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] of: add functions to count number of elements in a
 property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t4k3FX2BKM3OLyzG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2014 at 01:00:34AM +0100, Heiko St=FCbner wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
>=20
> The need to know the number of array elements in a property is
> a common pattern. To prevent duplication of open-coded implementations
> add a helper static function that also centralises strict sanity
> checking and DTB format details, as well as a set of wrapper functions
> for u8, u16, u32 and u64.

Applied, thanks.

--t4k3FX2BKM3OLyzG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5fcAAoJELSic+t+oim9gaoP/3ZiyCv+c3ehG4Or+FdUMveu
CHZY3VzSKgtpGp08MZGxJLF/5vvCTpRs0DZKYbysZSOkKg7k4s1dBeFJ6VCnaul2
6whWT1rEeWTDIorl2ZSuoKJSNlfSA35kfbCfpYQdGcZJH3hXtq0dANnTvtptGHsd
U4hASdyND0M8He09Oq+edQhgozDvUc7/waswl7BUJxEPZzBdPkporHPWa7Qx/KJV
sMYljsuj0dhGF4ovbjmng0n5ORURnYWUwCYw1G4UhbY31m5YASHVIQKQQbdTMYcX
jyK2mjJG3NwsHVr9i5Xkk5G10SB4VMzYcM/hBDnkk2CxXiwmxow36YKTIj0mDwgW
EiA/9txjWgNvIidqN0c/hRoQlXoaw/Tzri4zdVVyCrztl4dgU6NwR9kJgXMMNLXX
ymvePfA2J73T3e1SM7kskRTUtcRX53iLsoaCKeZ3eHvLdBP21Gy4XD+RZUPuG3lr
YMb5WlL0AyGWSVlbBvf2XyF5Y+2+4TApJLkYOTvCbvgXagNcE/NXqKhemgquXiDC
f+2yMlFVASD6Zbfht7lPDI24DJSp1aOu28+fA8/ATnqznhveXxocvFrt8RMpG2I1
fy4rDyNit/jhTDgsVOVyDbRk1kAhqTj2bBRud5SySj2fpTqXYGSFDlXdmjWSM2fT
YrEXMu4YKDAtXorGqgIL
=PaW2
-----END PGP SIGNATURE-----

--t4k3FX2BKM3OLyzG--
