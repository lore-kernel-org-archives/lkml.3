Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaCJJaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:30:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32935 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbaCJJaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:30:01 -0400
Message-ID: <531D85E7.2060409@ti.com>
Date: Mon, 10 Mar 2014 11:29:11 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca> <CA+gwMcfgKre8S4KHPvTVuAuz672aehGrN1UfFpwKAueTAcrMZQ@mail.gmail.com> <1536567.OYzyi25bjL@avalon> <531D7E9F.3090708@samsung.com>
In-Reply-To: <531D7E9F.3090708@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bIh8W89TUIJmlfTSEVOve9C1uhLTE6eBG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bIh8W89TUIJmlfTSEVOve9C1uhLTE6eBG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/03/14 10:58, Andrzej Hajda wrote:

> I want to propose another solution to simplify bindings, in fact I have=

> few ideas to consider:
>=20
> 1. Use named ports instead of address-cells/regs. Ie instead of
> port@number schema, use port-function. This will allow to avoid ports
> node and #address-cells, #size-cells, reg properties.
> Additionally it should increase readability of the bindings.
>=20
> device {
> 	port-dsi {
> 		endpoint { ... };
> 	};
> 	port-rgb {
> 		endpoint { ... };
> 	};
> };
>=20
> It is little bit like with gpios vs reset-gpios properties.
> Another advantage I see we do not need do mappings of port numbers
> to functions between dts, drivers and documentation.

That makes it more difficult to iterate the ports. You need to go
through all the nodes and use partial name matching. I think for things
like gpios, the driver always gives the full name, so there's no need
for any kind of partial matching or searching.

It looks nice when just looking at the DT, though.

 Tomi



--bIh8W89TUIJmlfTSEVOve9C1uhLTE6eBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHYXqAAoJEPo9qoy8lh71bKAP/0BLKbGZuSlBttYPCuKE2QgJ
3TrJWDTyxsLwyHZlaRf7r8E9uP15CpGiYdu3ki1uxs3JAfp6ISNWodcCTdBxBcIi
z7IzB9mrjkQ6pYBxA7wMqAbVBCyJSmQxBMUVkpC5ZhiFxXvphpzjDDCk/Ps4mAHu
RGVBWSfoijqjOkZFzqqSCbjeiOgDYTcBI9Q1Vl7T+g6hurVJ9QHq8Fa3dUzDXFZ8
zGqhVdSP5hDA9CpX5T4t668hx5LS6PQ9TZK/FAYTJ0FyJeELmuB3P+WOR4RwzcGA
zyhWIIA4FvwvS+BdUO430mVFs7u2wf7PrEkNknxvHiXjsZOxp+DkaV1E6xpJhqxL
IR4kMx5cW1bWMEoAz3op3xOFvtyzWQR4ycpAoQZirFl1AveyxW5xajGt1NYCKl03
Hq3bsUBsrnAt4ttSgprQudq45bd5wVKJK0NailEuKPwynmXiNphUVVqHTgDIPh8k
0oUw86GHYFXizJaDK3eLesiW1mnLL2SRs+fAf/5Pj4ZviBbKJHexgdcjR439xp0U
64eIEN7wGMbyFpFR9R8lJBdTS+Wqrlo6r01EOb3tZMcn/fanJomx75OCFO09vD3z
KFFWguKUx1GvL6q0Zx6vB/MYdifYnk1kQmt7dSW6vY630yRKJKHKj3rZ7Rvokycb
k5/gKLojCM7fmZaItMmo
=Yge3
-----END PGP SIGNATURE-----

--bIh8W89TUIJmlfTSEVOve9C1uhLTE6eBG--
