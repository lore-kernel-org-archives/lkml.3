Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaBZNOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:14:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55790 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaBZNOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:14:45 -0500
Message-ID: <530DE8A9.9050809@ti.com>
Date: Wed, 26 Feb 2014 15:14:17 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="P5XuDVSgpRe7oq63NjUpwRNaupJAvQLnT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--P5XuDVSgpRe7oq63NjUpwRNaupJAvQLnT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25/02/14 16:58, Philipp Zabel wrote:

> +Optional endpoint properties
> +----------------------------
> +
> +- remote-endpoint: phandle to an 'endpoint' subnode of a remote device=
 node.

Why is that optional? What use is an endpoint, if it's not connected to
something?

Also, if this is being worked on, I'd like to propose the addition of
simpler single-endpoint cases which I've been using with OMAP DSS. So if
there's just a single endpoint for the device, which is very common, you
can have just:

device {
	...
	endpoint { ... };
};

However, I guess that the patch just keeps growing and growing, so maybe
it's better to add such things later =3D).

 Tomi



--P5XuDVSgpRe7oq63NjUpwRNaupJAvQLnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDeipAAoJEPo9qoy8lh71kfUQAJhRq4j0qyfE4BGDXs+uIlkO
TfkI7j8C/6ISwDRsgW84HTsdOUUynHk+Yi2haW++dz+q65vtVbsXwZZEJBig+s7u
GURZkDuVYaO0Go4RltBAICKvPHyuiPFBw6R75i44pDurmzzGeIFyE4WO6fV0eY5R
l0arhQwYax78+fAonRiLpQ+qHAPA2eMn7171P6zkQ5DaIb4tN5KcfrzFnZJeLH7M
LwkgDo2lgixd9h1LjZB3av2WygnXW3HxVv9dZmTsizqoYw0FiQCg8uEnVYhevBBj
Zni9bftyryKQhTvpvOokvPmFAQWIB/xy2NnM1HHivhv2QsBA/Rp7yi3wLE4Rq1ni
rGh7Twq9P0l6/IFF0iffI+PoiK8K+mqbZjDrLyLjJsAE008JgILXE93xBubeaY+k
j5j1Qb08jPqzkKtpCOw2SXTpS2ZSWmWrJHt8x3joAQG4dzB3f5dKbapCi6EJ29Z+
9ppgINTtERFwnFaZh2onuk+/ogPMjuc/yS5LdU7NHkA5Ze4jqhgcIVguAljugaDX
dA7lkynRrb2tjAVhsoSygEQklRz5eYNBPd4g8hFx7mAgOeUgMMYxz3lRQ6J+wptv
/NjtZmn7dFeRjD6/0ru3SOjLwaVYeUPu/C/bQmzwsEoC33fqqbTIvA82m0zf3ROB
eObjYrE8uzOLi0TTSTC+
=TZyW
-----END PGP SIGNATURE-----

--P5XuDVSgpRe7oq63NjUpwRNaupJAvQLnT--
