Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3BPUVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 15:21:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3BPUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 15:21:20 -0500
Date: Sat, 16 Feb 2013 21:21:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: twl: Use to_twl() instead of container_of()
Message-ID: <20130216202114.GA18727@avionic-0098.mockup.avionic-design.de>
References: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
 <1361044472-6439-1-git-send-email-morbidrsa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1361044472-6439-1-git-send-email-morbidrsa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:esmYEU4feSQf+Mn1BZyskQzt6x178R0rVyM34l1akkc
 A3+flLGiXHiXy0D9EWc4BjwQbZwoOLiG2wv47F3S05Svbiy97z
 zrgR4E1CJb0KQoprRWCZ5TG3lCejhvkwMHEMsnuT7e1H1s89XT
 FLK8oCwMJh/RZANEkJiQ4DyIGtXyrgLOv0D4QO4prLF4yx/K3j
 yi/Fywvpfuufr7xZV2JovAQPRoRouEC3yRdeTJYcdWmQZrqstT
 cC7dhVoBYMoKURSmBcop2lAoYh01pi5jpiCL5TNDfc47SyWW0V
 nzRH2ziHRqu950VFKJcN30lzIEAHTRjR5QQLr41HDVNVdHj/UV
 lWNZX6lqDluOdl31pZ6hiC1FJOgP7hgHvrxjegUag3Gy5ei3D4
 TCLv1aYIUaNXicqnE31cffyRaDoq9DrKI//Cc/2CwXTMvsK6OR
 es4se
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 08:54:32PM +0100, Johannes Thumshirn wrote:
> Always use to_twl() for converting into private data instead of container=
_of()
>=20
> Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> ---
>  drivers/pwm/pwm-twl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

I've squashed this patch into the previous one and applied to the
for-next branch. Thanks,

Thierry

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRH+o6AAoJEN0jrNd/PrOh6f0QAJeTr2UibGh9PA7hOBhiblwo
JRYiHt1wgoMV0ngyJz75WSU/yYE/egqJT+CzLllI7EntIGPD+uvcOzGYyNCq58pp
nlhY1VHKPNfMN9evN7hQyg/r05zdu6u9A817fGJqNxRBpVpItEIhBmJ+kawLdrjb
cLN68VWJsMSRyjUmN7xKt/senm0ug9F5OQIJ27R35CVrsYXuuTrB/CiDnDZbCljc
fZrHOihehqTjXqhK5kDI4hb3eBf655xzfn2EhXtQOMJfAuoTg+Yf1TofjrG4PkVJ
/bLAGG7PhHkj2NIBDXEMYLt13xd/MMECkcIvtX/s4Bg28VY8M9VWcoypHmQh54eD
UG5zRRjyllkhE7qM3q+G8eWE037CBwB9JdDV0MO4Zmz4/SJ0kKuMl/Dgz7Q0UHUw
Xsxd4560Iw17NTlvBMyTosw1mE11kYWSCgIOTpi8h6GHMUrXZAx9AkEP7KwW+ffP
PAH8kiY7CM6untxqj4jCrm8zeHfQvIi1WtsD1TFuEIqsObdFDR+c0Y7SYvJVXbYI
2IhChCAptIDpgm5KOcfwaFTFo7YSVpkpHWk5zna0mzkvYUTEsQZWIRNp68TmxwFV
upO7lLEq3m84i/sVLfUStcDze1kJBbtL1hfjybjzsV8yd9eS8CIu5/hmv8f1AChr
QuWfFqZO1fc3pMm0dFLQ
=NnUE
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
