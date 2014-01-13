Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaAMKVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:21:25 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50622 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaAMKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:21:22 -0500
Message-ID: <52D3BE08.9040508@ti.com>
Date: Mon, 13 Jan 2014 12:20:56 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: <plagnioj@jcrosoft.com>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ivaylo Dimitrov <freemangordon@abv.bg>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH v2] ARM: OMAPFB: panel-sony-acx565akm: fix missing mutex
 unlocks
References: <52C956E9.2030008@gmail.com> <1388927585-5640-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <52CFD1ED.7010302@ti.com> <52D1113C.8020807@gmail.com>
In-Reply-To: <52D1113C.8020807@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="CfW55j6bPGffUtA8fVOg2aGCfbSSmU5iu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CfW55j6bPGffUtA8fVOg2aGCfbSSmU5iu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-11 11:39, Ivaylo Dimitrov wrote:

> The patch does not apply cleanly on top of rc7, however I applied it by=

> hand. So far it seems it fixes the issue brought by
> c37dd677988ca50bc8bc60ab5ab053720583c168, though I didn't test if
> mutex_lock/mutex_unlock are complementary in every code path (at least
> not explicitly, I guess maemo is doing it for us anyway :) ).

Ok, thanks.

> So, shall I send a patch incorporating your code changes, or you will d=
o
> it?

I can handle it.

 Tomi



--CfW55j6bPGffUtA8fVOg2aGCfbSSmU5iu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS074IAAoJEPo9qoy8lh71Hv4P/jE1pYG73S+pUguy5NizyjMP
O6z5Hi3GwdjOouQ345O/hPngwdTppjln8aSWX0luxKAPO9e0+Vc76lFZhC6qRxYD
TTOc6fQKuPh3eoWFYqnMlaiiOWx5mSrviCS9zVgfVSkcglBluN/cgWn4eHvNFxYl
JE/i0wLlvAW8boDRodxMEXiIbzNU2XKs75SQmCkJU2rAw5Zu6DpNGiDwrHiziyqY
GOU8jm/UBoKuhxLc+9lKhicGeYKJ0sqnDa/T6C2tL8wBfoo5qBkfiCxCD1/pruLY
bQnNy7pY0DVIU9JaI+YrrOuCdlHBiqlziKwjl188/6XPQSwaZLq3YDSoUIkMcCaq
rZSulgPcv1FWcxp2mOtxVt4gwh7NCsyMwz7KtQ8blw7Ia1mDzTOGLP/ZNmVAc5fG
e7lXo6HlO5RD+jsYCcRlFcjNQodo/wfDd7fwZBY0StteIBqWqJtO7RU5m4cribzT
RXcfgzphFKoMRtn/CAe+fIaiNExblV8Fy7b8Axu9gGGsCvtc7mex1nubqhBLNkrO
25yGTiXITEkTZaUkBxNP/L6x0WZmFyNbciPuKROkrPbuIQyym96J29FBxJi6Dxrq
VMQ8CBgWprJsXdfvEJt0j3EDKaBxUtoUDU6gmpHMSxZmpO26XMVMg1+drafV/R2R
pAqspJc9gREKZvZklpGB
=mRF4
-----END PGP SIGNATURE-----

--CfW55j6bPGffUtA8fVOg2aGCfbSSmU5iu--
