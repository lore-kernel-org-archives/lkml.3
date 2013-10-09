Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3JIIhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:37:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51184 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab3JIIhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:37:22 -0400
Message-ID: <525515BA.90603@ti.com>
Date: Wed, 9 Oct 2013 11:37:14 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: sh_mobile_hdmi: Use devm_kzalloc()
References: <1380809067-4245-1-git-send-email-sangjung.woo@samsung.com>
In-Reply-To: <1380809067-4245-1-git-send-email-sangjung.woo@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="6QQPWR9IjT0LXMtcVtviXRq835f6xrFbH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6QQPWR9IjT0LXMtcVtviXRq835f6xrFbH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/10/13 17:04, Sangjung Woo wrote:
> Use devm_kzalloc() instead of kzalloc() in order to be free
> automatically. This makes cleanup paths more simple.
>=20
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/video/sh_mobile_hdmi.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Thanks, queued for 3.13.

 Tomi




--6QQPWR9IjT0LXMtcVtviXRq835f6xrFbH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVRW6AAoJEPo9qoy8lh71SWoP/0AU60HyanMU2Tluqxy8dpKm
79GlS2oZI57BgNlq5Tzy8y6m53BiIkQqCS5jHLWzM62rkWrnXU4rjawfymYCR+7H
oDPuJMypUGESas2/TRbXi+jrtxyJauUUdV9Zjgc1rVFSDHo1j0n213p7id8tl+uT
awpcT/g7ksy1XX5njMhnf47bl0xGND8e2ULcPW7lZwAmsh3jk08qhJZy0Pu+6yiT
RleiHFUAj2jpe4ewV2AXPhZv9b7cycT2y/4tKawiASkBeUZbdWGDI6Rf6cwb7ALB
9n0H23mUuAXMi9xhNxcN2wC6ikQLIvOMpQPt+fmy1lqbb30d1t3DfHRW7ZwXDvCU
J1Vah0Zpaa7R5WH0uMV/3fdx0EX/bI/LTm2VcqWwomKvSoG0svXnUHuLetj3COul
41Y0oFPLayJZn5T48Vv6J+KW9S6OJJ22SVj55el/EL0X7kIHVUPM9X1TgRJg5+88
d3US7i+Xc75XBTP/qetHg8fllqse60iXBvzreQsCgXDY2WFEacBI9qNNX5o/ursW
p9kd3n+4Pr+KNCNRddHFyB1foXrJcIdI5b5lvpmr8s0LkWZRSLDVW87RsNMkovFc
Y+gQ8iphIWGnBQTBc1GS1vueRhGNL2z4c55t3Hxc9kw1MmfWwB4xwZudKLlE6HY6
r2oCU+165idZElD5MtxR
=pjcO
-----END PGP SIGNATURE-----

--6QQPWR9IjT0LXMtcVtviXRq835f6xrFbH--
