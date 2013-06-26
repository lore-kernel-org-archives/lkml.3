Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3FZMLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:11:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54934 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab3FZMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:11:07 -0400
Date: Wed, 26 Jun 2013 15:10:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>, <balajitk@ti.com>,
        <george.cherian@ti.com>
Subject: Re: [PATCH v9 1/8] drivers: phy: add generic PHY framework
Message-ID: <20130626121000.GZ12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372247257-30186-1-git-send-email-kishon@ti.com>
 <1372247257-30186-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3cI6DWK3Xt33P8nt"
Content-Disposition: inline
In-Reply-To: <1372247257-30186-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3cI6DWK3Xt33P8nt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 05:17:29PM +0530, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to =
the
> PHY with or without using phandle. For dt-boot, the PHY drivers should
> also register *PHY provider* with the framework.
>=20
> PHY drivers should create the PHY by passing id and ops like init, exit,
> power_on and power_off. This framework is also pm runtime enabled.
>=20
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for dt binding can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

looks great to my eyes

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--3cI6DWK3Xt33P8nt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRytoYAAoJEIaOsuA1yqREJxQP/iPE0WrYsa7JnctOcRP4XVnW
GlMDbFMhAu7pQ0pFYbb7u4vHFs4RZdOqPsA5QHgbVzYxwZ5pcEOMtiwBtoh2GedK
XM8l7Z5oO1LIeaUOvR4VG7ivo8jsyh3/i/7Y1v8Lj/298BdEudsLJYQHr/lZP0wt
WRgwbDPBEVQjE5Z/9XoMkAWOnKhOmHcdgkd+69ORwudHleeNVmr+VsEgxHfS+XEK
GSLopAFIgLm92PSP4XXxoTFzVd2bZ8PpGu2rQv2BoMdWNTgoet13Stok28hlNq+8
kkINa7NyujVZrH2IgVaQbGDhS586xunUugUFxargrbZ3ySAiJILbm4vQ9xQ8Y/op
2Hl41MDhjcKfQnKEVXWndsUIWhhvAjeggAFCpJ3/PyyScNGDug222xxFKZYCdUZv
BXbrXgkq5r87MdMEVGk3TrVVcGJWGb1mfew4jzpT311MqPlWakKWbT48ezuKyIYt
rrcIO1GEctDVQofkkG21c20RCpsfFC3ZEYiWhXZZz1m2mnx6rZYS5ZKT8xXx8vZb
NTHwTCDD46P1+acZoVa29jY+5kza7/lUUsUqPehEyE4mtbvhsp1QXg7KptNa476V
UmtgFF08tmQEmJi/xDM7DwQEKv4jI1JDw6IPXkN1Jihe3dPEzvtD5TRToyeEBuI8
lgdkW9uGDLfNydx+5W8w
=5RxU
-----END PGP SIGNATURE-----

--3cI6DWK3Xt33P8nt--
