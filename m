Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKLN66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:58:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59001 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaKLN64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:58:56 -0500
Message-ID: <54636763.10605@ti.com>
Date: Wed, 12 Nov 2014 15:57:55 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <plagnioj@jcrosoft.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH 1/4] video: omapdss: Add opa362 driver
References: <1415051968-4878-1-git-send-email-marek@goldelico.com> <1415051968-4878-2-git-send-email-marek@goldelico.com>
In-Reply-To: <1415051968-4878-2-git-send-email-marek@goldelico.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lubUgX1x7F5LjjcrHrV4sKjeTAMTfe989"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lubUgX1x7F5LjjcrHrV4sKjeTAMTfe989
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,


On 03/11/14 23:59, Marek Belisko wrote:
> opa362 is amplifier for videoand can be connected to the tvout pads
> of the OMAP3. It has one gpio control for enable/disable of the output
> (high impedance).
>=20
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
>  drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
>  .../fbdev/omap2/displays-new/amplifier-opa362.c    | 347 +++++++++++++=
++++++++
>  3 files changed, 354 insertions(+)
>  create mode 100644 drivers/video/fbdev/omap2/displays-new/amplifier-op=
a362.c

This doesn't even compile:

drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c:207:28: error:
dereferencing pointer to incomplete type
  ddata->enable_gpio =3D pdata->enable_gpio;

And it seems to have fields for bypass and bypass which are handled in
the devconf1 patch.

 Tomi



--lubUgX1x7F5LjjcrHrV4sKjeTAMTfe989
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY2djAAoJEPo9qoy8lh71xbwP/2BBJi+3w+xIY+DHFWmv44f3
fynP4Gev891QE6eZ/JD/I5DBJ07z3KuwLVOHMIyuCT94p4Dwgb93so6la8m2wJ7k
llgPrJaFy8s740rpWGj8S9MD3TgEv5nWCArhTpFLdAC1t1akN1AQmuzRGcxfMNzO
4Djb0GLsEKxVQ/5dzPFBmjL+78WM0E1j46AKEDai+FiSDO7e9ZHpTYxmIKv0BJOI
exvWpRgZrtpObm4/6BdA55F6QoWipSvdNYldS41N2HR4ecZeXEe0uCOgVc3f74dz
42zGyUTmCCvTTLnEMZmgIhsqdR/+sFOG5Fm0kSRTFa7bG5KpCJGq1onp3AdZ4Pw7
jP5MmnQl75iM59iK/2KmPXLhrDcJ06zXnv01o87SVmxFnW94lruggB/N0ySSSAIg
qp7A9nAweSzIZTJ32qJz0ATAP30mQqshC2nAbdeUxCB+4CYamH1ZGc/X+zyaC1AJ
YMQ5Ps0EBcVCMfowkL+tR+YXaAhgq74XwUuVy/hqiwQCySCYSglGE1xkD3Pg7knV
yUM8Zo3z31MeA5aIhac1/X5gfiNQEX5u/ZLuB/U66KeYNxTAW6hlefz2DJ2Muop4
SaLu3UtuHBEm5N5/fU7etL+2Lh2WgQEd2atOrNAA/IgzF1P4DzVz4OBsiF92Z7s0
j3QHdbReqAuk/rzd+4eE
=bxRy
-----END PGP SIGNATURE-----

--lubUgX1x7F5LjjcrHrV4sKjeTAMTfe989--
