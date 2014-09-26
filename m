Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaIZKT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:19:26 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:63997 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbaIZKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:19:22 -0400
Date: Fri, 26 Sep 2014 12:19:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <cyndis@kapsi.fi>
Cc: edubezval@gmail.com, swarren@wwwdotorg.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, juha-matti.tilli@iki.fi
Subject: Re: [PATCH v6 0/4] Tegra124 soctherm driver
Message-ID: <20140926101918.GM31106@ulmo>
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jdM5ZcN/ZcXXVwZs"
Content-Disposition: inline
In-Reply-To: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jdM5ZcN/ZcXXVwZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 12:43:09PM +0300, Mikko Perttunen wrote:
> Hi,
>=20
> this series adds support for the thermal monitoring features of the
> soctherm unit on the Tegra124 SoC.=20
>=20
> The branch is also available in my github repo,
>   git://github.com/cyndis/linux.git soctherm-v6
>=20
> Thanks,
> Mikko
>=20
> Mikko Perttunen (4):
>   of: Add bindings for nvidia,tegra124-soctherm
>   ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
>   ARM: tegra: Add thermal trip points for Jetson TK1
>   thermal: Add Tegra SOCTHERM thermal management driver
>=20
>  .../devicetree/bindings/thermal/tegra-soctherm.txt |  53 +++
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  44 ++
>  arch/arm/boot/dts/tegra124.dtsi                    |  47 ++
>  drivers/thermal/Kconfig                            |  10 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/tegra_soctherm.c                   | 471 +++++++++++++++=
++++++
>  include/dt-bindings/thermal/tegra124-soctherm.h    |  13 +
>  7 files changed, 639 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/tegra-socth=
erm.txt
>  create mode 100644 drivers/thermal/tegra_soctherm.c
>  create mode 100644 include/dt-bindings/thermal/tegra124-soctherm.h

One thing that I've wanted to start doing for a while now is request
patch submissions like this to come accompanied with a way on how to
test them. Ideally this would be in a scripted way that can test for
success programatically, but it doesn't necessarily have to be if it
turns out too difficult or impractical to do.

The goal is to eventually come up with a test suite that can run the
majority of test cases automatically to make it easy to test for any
regressions. And even if tests can't be run automatically it'd still
be an advantage to have them all collected in some repository, since
it saves a lot of typing and time to run tests, and it will give us
a standard set of tests that everybody can verify changes against.

I realize that it's somewhat unfair to start requesting this from you
now, but we've got to start somewhere. Could you give a short summary
of how you test this? What are the interfaces that the kernel exposes
for these thermal drivers?

Thierry

--jdM5ZcN/ZcXXVwZs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJT2mAAoJEN0jrNd/PrOhGE8P/20gBfQEJ3cCQ2ZJNuDk7OsQ
FmJOXkeGyAmpogK5uLut2eFolmlnpuPIRxDVUuyLpiac8GPwl7AgpsbkUmI7u54O
Zt7gSwLE6jwKHS73fIK9CX+qWBrcXHAZD2n5nyVT58xPKaaXVWSFOBsCtGP7bNrj
bXOLlIYlSburzUvPe3Xte2XmFXUMkDnx9ye7bYORiIdhVKH6hW/1sJeAHHRZmtcX
mtx5ZJs6nR0bZhArmYVZinHDqRMas9tHS57pkGzkEFOUj1MG6L0doyyPn/38bg94
vpiAK7Y+CnlRlC+Boa92X0h5SHvUPsDyjv1t38DebPcWze24XHwMfJxZbNfu6mRo
+JJ9heFyB4kcxOaoStpClen5OlqFGK0fFy9FrRaXrbTNsPD+W54GrwwH1BVeAZPp
EEBho/Zw+O3rJNYupXv2JmDdsO1jdaVRyW+pgZmYYv8ssOE2xIWvCipN+DOO67Gx
y9yts8RCcwLx4j5oHfp27O6XVVgcv5r6AKyNdH33r9PDjViIruQxj6YUdsr9IZl2
XSkd1KmvH6tlhO3j2560gfQA9Ain/VovJpmjfAkfGrDP2iL2y4QmPYGxEE9y0wvC
UVfyOmaNAnCMdbAhvDPJvHKXnXsBCbcR57qDtoEP6bxLS0le0JvFawynDjaVwzS2
hH89fpS0+VCFKTWiFjpK
=m7uS
-----END PGP SIGNATURE-----

--jdM5ZcN/ZcXXVwZs--
