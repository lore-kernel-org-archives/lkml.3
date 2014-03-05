Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaCELf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:35:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44328 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbaCELf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:35:56 -0500
Message-ID: <53170C00.20200@ti.com>
Date: Wed, 5 Mar 2014 13:35:28 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Ijxt5XB3RhGk7AVmrWSf4NnRCNT4LOlEX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ijxt5XB3RhGk7AVmrWSf4NnRCNT4LOlEX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 05/03/14 11:20, Philipp Zabel wrote:
> Hi,
>=20
> this version of the OF graph helper move series further addresses a few=
 of
> Tomi's and Sylwester's comments.
>=20
> Changes since v5:
>  - Fixed spelling errors and a wrong device node name in the link secti=
on
>  - Added parentless previous endpoint's full name to warning
>  - Fixed documentation comment for of_graph_parse_endpoint
>  - Unrolled for-loop in of_graph_get_remote_port_parent
>=20
> Philipp Zabel (8):
>   [media] of: move graph helpers from drivers/media/v4l2-core to
>     drivers/of
>   Documentation: of: Document graph bindings
>   of: Warn if of_graph_get_next_endpoint is called with the root node
>   of: Reduce indentation in of_graph_get_next_endpoint
>   [media] of: move common endpoint parsing to drivers/of
>   of: Implement simplified graph binding for single port devices
>   of: Document simplified graph binding for single port devices
>   of: Warn if of_graph_parse_endpoint is called with the root node

So, as I've pointed out, I don't agree with the API, as it's too limited
and I can't use it, but as this series is (mostly) about moving the
current API to a common place, it's fine for me.

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--Ijxt5XB3RhGk7AVmrWSf4NnRCNT4LOlEX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFwwAAAoJEPo9qoy8lh71JEsP/03+t53g9vANGhDyiOXREbXb
IEaTqZEKLSF0gK6VP3wmOhDwKbM10Fs4pF4J4RgxZhr5uFRjMbm9sNg/mdurGFMq
hxdH0er2i7sjIMU+aEfMQ59VvvLelkDjE5KhafHqf9HGuSNIjrVSdA47zrawnxiJ
RWtJ3jNi417S+N4x8THoCZk3tScdVt2lIe+AHrvxdZDoLU2UyBr0FNXyxYDz3qwu
NkUipsQEdaTmgMkDtNrFgLY1Prp8pLNeP5arHnrQAhK8abrhijM1Zdw48flRxsx7
GUn5n0FpooIUW3vthAD3CZkQ55qr9/2ux5r1t27YZw21o6oFLk01GlLz1F7bS9vX
YHtTtnWvPjYWEx+PokQdfjrXssYxDXDXznztlpGBUb+JcegYt9Fe0MAqE739LYKh
q7IDmiAfSk4Xug1Z4QeD6H8y7hLyqbaU55L12/0SuHeVrSmXrhJZx3+cVqYC5X58
g/80BQ2GOOUOtiWEGEWMp/vC8x7Zbpejfu4sKDH2Dy5VNPAGkXRmd5zkyy1GGQFz
VgYwDl5Dxvxpfdq+oAIq3Ek/y48q/t9YMm1fgc/5nT16axJcLErPpvOavWqwRJ4T
VU2RIXli2hWmQw0fIOsy1444vDGV6alI1DJ4NnmO5zaTzDIbx2/rBRT+aAx9eky2
VyshKqNekhVO41mv3F3g
=TPD2
-----END PGP SIGNATURE-----

--Ijxt5XB3RhGk7AVmrWSf4NnRCNT4LOlEX--
