Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaLDIKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:10:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52760 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaLDIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:10:15 -0500
Message-ID: <548016D9.6030006@ti.com>
Date: Thu, 4 Dec 2014 10:10:01 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "alexander.stein@systec-electronic.com" 
	<alexander.stein@systec-electronic.com>
Subject: Re: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com> <4810522.t9QFQYHtHI@wuerfel> <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
In-Reply-To: <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8tqXasC1lCUUku3032PcGN7ldMDEfv754"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8tqXasC1lCUUku3032PcGN7ldMDEfv754
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Xiubo,

On 04/12/14 03:56, Li.Xiubo@freescale.com wrote:
> Hi Arnd,
>=20
> Thanks for you advice.
>=20
> Because this is very emergency for customers and have delayed for month=
es, and the
> DRM/KMS will have a little long time to be supported. So I'd like to ad=
d this first
> and will add DRM/KMS version later.

I would also suggest to just write a drm driver for this. I don't see
anything special in this driver that would be better supported via
fbdev. With drm you'll get a more modern framework, and you will still
have the same /dev/fbX device to use for legacy userspace software.

What do you mean with "delayed for months"? The first version of this
series (that I can find) was posted less than two weeks ago.

 Tomi



--8tqXasC1lCUUku3032PcGN7ldMDEfv754
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgBbZAAoJEPo9qoy8lh71sbkP/iLJXw/btKoio5T4ORqPfN9K
PigiPBO3GcCRKnSI6rKKtqLypjoepjYEojtmaEqyFSXTsb7OJJIJKhZG2uWCfPfs
os8rl3eVraSqu8uNX/U75WohEdbnFeCzwwUoNJ6IrArz3XcjAPD88JeOZ2qQg1ss
Q7LuaWK+J/ZNl6PELVXJpE7jWi9yx/emCHRn7EzxiKGdGRpJ6u1E0jdiIIz73Y68
b4cOkt4FBMOsJb8Ynznj+UL6000y/4QfBtaocwOhlI60MDMXdTzCDQmVG4rkkauZ
hpBDROVzgzyA1BQfgXAhlydMW892CsZQMA/3RZfPUL2Y5YQuZDzodmDbHxHRJjj6
btUp2dThsBdGcfdlFqsfohiYuC8DniKnoRh7DXzokKHznf1Jjzy1bojQLDvUNy6U
CccZdEcjRphuibFRJjBQFQ2q2g0zpsqfRJjG4rVtTV+rMtxnSJDI5E5A2DxkB07F
Jl18ybn6YJLQ6L+v7/NIolIcLdcfIS92rq8JCCpw/kqAjoREVi+QihjAk6xCelZR
EhXeOKsNz4PgBWF/iH5ytMSoJpGdADnYGAnS7C3FNnMubeJm2s7IC5h/NhT1+3Ty
CiEoxmuhI60GG7tlDbU0LWQmdiJV7uH+xonBsL39Y2w3WfRu4wbcxA9GQiNvRPJq
7D63nwTdAYNoI3sxs4BH
=7VB1
-----END PGP SIGNATURE-----

--8tqXasC1lCUUku3032PcGN7ldMDEfv754--
