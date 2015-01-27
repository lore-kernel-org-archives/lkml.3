Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbbA0AiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:38:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbbA0AiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:38:03 -0500
Message-ID: <54C6DDE8.3000905@suse.de>
Date: Tue, 27 Jan 2015 01:38:00 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] ARM: zynq: Remove bogus value from 'bias-disable'
 property
References: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="x7OTP5ALlf0PUxDlivFv2jtqOb9stSVwM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x7OTP5ALlf0PUxDlivFv2jtqOb9stSVwM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 26.01.2015 um 20:49 schrieb Soren Brinkmann:
> In one pinctrl node, a 'bias-disable' property is erroneously assigned =
a
> value.
>=20
> Fixes: ARM: zynq: DT: Add pinctrl information
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Reviewed-by: Andreas F=C3=A4rber <afaerber@suse.de>

Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,=

Graham Norton; HRB 21284 (AG N=C3=BCrnberg)


--x7OTP5ALlf0PUxDlivFv2jtqOb9stSVwM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxt3oAAoJEPou0S0+fgE/OgMQAKMHENAvD2Sl4Z2wkLszdq+n
xC/d/8mD51o/95ByFKkMx0EjjFF43DOxJDGUbqcHzOOgfGyv0scDatFAqxWEabMC
GnCbMJeFqUkaKhgQqhHCPwhYvMW6MFnA2VPcbhk8KyYY9Qhjlbq8xLyNUtWPYk6U
s2LtzPoLn7R7r9JGZGPOpF0SMU7gB3htABqgNHSwN/L3hkKLRdmAL/mXBAxa6Qpp
M+vxiDOwjzPdYx2+x6FX9kdXEVyyO1vp75YCSrq3VCiEZwt2gqlm1voPljdlcFKD
5hUpsnbS/Jh+HvmxbuWRN1tyJmwEln3C8Zfy0ct8b5FRP7DHem/nmKeI/kzhobyl
7fh6a3JV5GgfNCQk325AecONRiMwmdikxOmCJJsiDzrNb4HrZQsR/1Q+o/RV8LZv
lfHA8+UjUVGcgyLtyLu46lx4xGa2PHO/jrMFj9wVqbkTTm05xhBmKCDwh7SNdBhi
isZ9M4kDcnELrkd8DW6yRSuaZJp+1cNw1Cor0UVKfNgp5CJO6fAYqlThtyZdmuul
mSSgUh18IN1/OInbXDurQxETEaYqrs3SfogofMAhZmHa/9cRzDQ6PX9kVTXrLSQh
GIzVwdhpyCZcOwtq11JoWRsOc5h8hRDzfD0bOVmXhfqGfxVUM8bOu350DBw3h4Om
aG1sEn/O9dcbKqTmJy5f
=xgpu
-----END PGP SIGNATURE-----

--x7OTP5ALlf0PUxDlivFv2jtqOb9stSVwM--
