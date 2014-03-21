Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaCUO2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:28:35 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:41641 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCUO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:28:32 -0400
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
Date: Fri, 21 Mar 2014 15:30:20 +0100
Message-ID: <1658201.GilyGRJEEa@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <532C4B3C.4030406@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <1755937.SSGT2MZJMC@avalon> <532C4B3C.4030406@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1422452.LVKZ4jzxXA"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1422452.LVKZ4jzxXA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Friday 21 March 2014 16:22:52 Tomi Valkeinen wrote:
> On 21/03/14 16:13, Laurent Pinchart wrote:
> > On Friday 21 March 2014 15:37:17 Tomi Valkeinen wrote:
> >> On 21/03/14 00:32, Laurent Pinchart wrote:
> >>> The OF graph bindings documentation could just specify the ports =
node as
> >>> optional and mandate individual device bindings to specify it as
> >>> mandatory or forbidden (possibly with a default behaviour to avoi=
d
> >>> making all device bindings too verbose).
> >>=20
> >> Isn't it so that if the device has one port, it can always do with=
out
> >> 'ports', but if it has multiple ports, it always has to use 'ports=
' so
> >> that #address-cells and #size-cells can be defined?
> >=20
> > You can put the #address-cells and #size-cells property in the devi=
ce node
> > directly without requiring a ports subnode.
>=20
> Ah, right. So 'ports' is only needed when the device node has other c=
hildren
> nodes than the ports and those nodes need different #address-cells an=
d
> #size-cells than the ports.

I would rephrase that as the ports node being required only in that cas=
e. It=20
can also be useful to cleanly group ports together when the device node=
 has=20
other unrelated children, even though no technical requirement exist (y=
et ?)=20
in that case.

> In that case it sounds fine to leave it for the driver bindings to de=
cide.

=2D-=20
Regards,

Laurent Pinchart

--nextPart1422452.LVKZ4jzxXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTLEz8AAoJEIkPb2GL7hl1VvAIAKrdmomDTdcBJr1NaaefFaQK
2pA7MWuE/RRkUmMe2HjAfqqapyEW1sMJ9A0R5NUy3JC/7xmu+rEtm6VyBja5v6kZ
O8bd3mFpER6KPWS8GZPQJ2QT3cnTOQKpuybZRDmIFPMGhfnqq9nfW69U4QjlbfKs
VFghO8k3I+fUzEql8meii6GRwtSdMWWPsyncf94a8Wj93mY+tNhtibfpeFoxhmU/
UiKm1+xYcRxJ5gWuG567BMlGACsYaI9uSv/WWDmLZHW0CMJ2J2NWMSYSvxBNFtlm
+aVRGBHVVMAPfj8zI8LKelHqtz/ieJpDxuyNHWuXE3LJiAhWUPhvW2dkhBCGlWo=
=Qk0J
-----END PGP SIGNATURE-----

--nextPart1422452.LVKZ4jzxXA--

