Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbaH0T4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:56:15 -0400
Received: from sauhun.de ([89.238.76.85]:58390 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbaH0T4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:56:14 -0400
Date: Wed, 27 Aug 2014 21:56:13 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: =?utf-8?B?Sm9zw6kgTWFudWVsIEFsYXJjw7NuIFJvbGTDoW4=?= 
	<jose.alarcon.roldan@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c documentation: rename variable "register" to "reg"
Message-ID: <20140827195613.GA1549@katana>
References: <CAGhpvoqrFQn7z942jUr2T8D1tuzS_irTqwmUynnqG55SVe3CqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <CAGhpvoqrFQn7z942jUr2T8D1tuzS_irTqwmUynnqG55SVe3CqA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2014 at 10:54:21PM +0300, Jos=C3=A9 Manuel Alarc=C3=B3n Rol=
d=C3=A1n wrote:
> The example code provided with the i2c device interface documentation
> won't compile since it uses the reserved word "register" to name a
> variable.
>=20
> The compiler fails with this error message:
>=20
>  error: expected identifier or '(' before '=3D' token
>    __u8 register =3D 0x20; /* Device register to access */
>                  ^
>=20
> Rename the variable "register" to simply "reg"
> in the example code.
>=20
> Signed-off-by: Jose Alarcon Roldan <jose.alarcon.roldan@gmail.com>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/jfdAAoJEBQN5MwUoCm2TA8QAKc3jG2SB8wghKaI1umvqYaE
Tm3uTNTC6mU0Uv8jm3c6lbQou12VavxMjK0ciLK2TXX8gULjfmbuCLdO7+HSB6Ha
rVViUXCD9Lst8k9ioFZOCIWSLoBHZcyOt974yQ8knBFcgq41k2gNaOebM8hxmh+s
IXqRFxftN1ukuGAg5ztxcNnGTfpz/VQSQ+LLPf/ZAQXn2jp/WXM0Vnmc5mwUJ6uc
1if8URqMro52uED/m0CCeX4Qom+j3HmCkc462UgAMeEssrh9WLF+Fb6Wl+LTmrh1
gEnd14hmhdsMNNX2JoTiAAvS0Xg5ZHqxumtq9w6meOmbaLkTRtlcudvRRLw1dHPv
R4t9MHAx35q75eAqUoCptYdjCOzy1fBO9pul8cPJDoXIhI+3wf4Vfir1Ef8wC7rx
lC/3iryYIEUM3qfBizG0GEKw+rebVrBDZ3uxZ4I8nUpxPbCfnbKEQM3/zIfFkFls
ofaav/MUs8eN4hRBEL0m7Vc92VYyCS8bcMZxrywlTI9Is/xIch2zid8Yy0LG2BGl
5kJgatu9hhEU8xEs1KJ9+uxKB1iXI/dYNouTaIpyCFlfysdTPwFHgQI8i8Qbrqbb
MIb54LJFh9Qrbzw7MinYlGqzVj6isvGyt74SlfaUHNkLTgWQvXiQTuKmdnC666ZD
49TE8WHTExtFzdzCM+ss
=GBLg
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
