Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaCUOL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:11:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:41544 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaCUOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:11:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Fri, 21 Mar 2014 15:13:38 +0100
Message-ID: <1755937.SSGT2MZJMC@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <532C408D.4070002@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <2848953.vVjghJyYNE@avalon> <532C408D.4070002@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1481097.JvJTheO4j4"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1481097.JvJTheO4j4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Friday 21 March 2014 15:37:17 Tomi Valkeinen wrote:
> On 21/03/14 00:32, Laurent Pinchart wrote:
> > The OF graph bindings documentation could just specify the ports no=
de as
> > optional and mandate individual device bindings to specify it as ma=
ndatory
> > or forbidden (possibly with a default behaviour to avoid making all=

> > device bindings too verbose).
>=20
> Isn't it so that if the device has one port, it can always do without=

> 'ports', but if it has multiple ports, it always has to use 'ports' s=
o
> that #address-cells and #size-cells can be defined?

You can put the #address-cells and #size-cells property in the device n=
ode=20
directly without requiring a ports subnode.

> If so, there's nothing left for the individual device bindings to dec=
ide.


=2D-=20
Regards,

Laurent Pinchart

--nextPart1481097.JvJTheO4j4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTLEkYAAoJEIkPb2GL7hl1O/EIAI7GZa+/PoYcUZH7msuy322R
9u/uWub9R4lPngV/kPiPygxV7UbWRlvv3XvhrZxrQ8m8j0U080ukVZB2JJ6ewksD
pdYr2BwKcO6JsOeCe9WiAfxxj8urJjv2dRM6lTFleR0tamgJqzIS9RcApIR+FWuz
DEr29k92DVQ2+EIQj/tdlFQHazaH5r9Nh1IyIYDo4KwUWXVUManVIRl3ioE+D9MZ
4+D6VNwsuaWGrw34L3Cfy7mfe2MOH1LQIvgpXP0/IXyUfK4LHgAh02I0QlsXbEnQ
3/P11+fNSs9PiLfzaGKtP+Bklkr6ZnO0BqUZ0UWVHp01bKtAtDOb2Z9KIW15CtE=
=NnJ/
-----END PGP SIGNATURE-----

--nextPart1481097.JvJTheO4j4--

