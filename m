Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbbAMLJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:09:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40127 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbbAMLJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:09:36 -0500
Message-ID: <54B4FC9C.2050207@ti.com>
Date: Tue, 13 Jan 2015 13:08:12 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH v7 1/3] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
References: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de> <1419340158-20567-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1419340158-20567-2-git-send-email-p.zabel@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="wnR2XfbTETJWxvR7a7bCjC4m1HjK6iUKh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wnR2XfbTETJWxvR7a7bCjC4m1HjK6iUKh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 23/12/14 15:09, Philipp Zabel wrote:
> Decrementing the reference count of the previous endpoint node allows t=
o
> use the of_graph_get_next_endpoint function in a for_each_... style mac=
ro.
> All current users of this function that pass a non-NULL prev parameter
> (coresight, rcar-du, imx-drm, soc_camera, and omap2-dss) are changed to=

> not decrement the passed prev argument's refcount themselves.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
> Changes since v6:
>  - Added omap2-dss.
>  - Added Mathieu's ack.
> ---
>  drivers/coresight/of_coresight.c                  | 13 ++-----------
>  drivers/gpu/drm/imx/imx-drm-core.c                | 13 ++-----------
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 ++++-----------=

>  drivers/media/platform/soc_camera/soc_camera.c    |  3 ++-
>  drivers/of/base.c                                 |  9 +--------
>  drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +------
>  6 files changed, 12 insertions(+), 48 deletions(-)
>=20

For omapdss:

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--wnR2XfbTETJWxvR7a7bCjC4m1HjK6iUKh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtPycAAoJEPo9qoy8lh71exQQAKqNGfJfjw4sIvbukVuTUPFd
pCQXUm9CR90RlszlrkdD3VVUGYaxEbbRMHprEDfzxe+hxZbkP63gABo0kGVQhN3F
TAITYLsCGqU5kNivacUBIGuNLAHwjbkjFySf2NuhCPJ82FttqWB9WDBj42EUlbL9
+pGAKyIm7MweTWHo6IhyEdZbBvmrfwD/j6NENo7dIP1uunrPR+3L/g8VzTzvlf6V
geHqFbbTKBD2A23BjPgykqLkuEblLaxkS5qRHnX9MIfSDCWK1cO29UyiOnvqwXnN
nTm9lvsq+RtR0xTmYPVw3P9R1coXPe1fRNgTErb5apI5DB9kdPyWVzSy7D6H5YYr
QOUohxV2P4EMi29rsj5IKMtSQFR+TVquz13qrPstYbpW2XpcujAGmbOS5bgI+ruh
9Mfw+8KRym/xP8LTVjdFwiKlnmGaZdzzIQsqm8oINE+Q4SW4o4eaEjj9URa5UQle
o1JvK9QQTuMwQR/aV8to11GLXyNhx4cNbUW0JyyHG4z/4S8xNUYrVgKfGSLHkrEm
Nnl64TQRKnk3a84qGLbcEMR1pZ4zSzEjSSDSz6lfLR8lxFmRTRAkpPQ6z80Xzdnj
pJbxqfDQZRv9bloFjZtLLMnYErEWGX623787tmotD0yeswUk57K8kccBk9ULyrC6
qXQFulsuc9dX6Ao/rbY8
=cGFR
-----END PGP SIGNATURE-----

--wnR2XfbTETJWxvR7a7bCjC4m1HjK6iUKh--
