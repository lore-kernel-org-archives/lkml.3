Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3FYPUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:20:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60902 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3FYPUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:20:38 -0400
Date: Tue, 25 Jun 2013 18:19:53 +0300
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
Subject: Re: [PATCH v8 5/8] ARM: dts: omap: update usb_otg_hs data
Message-ID: <20130625151953.GJ21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
 <1372139926-3719-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="utPK4TBebyzZxMrE"
Content-Disposition: inline
In-Reply-To: <1372139926-3719-6-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--utPK4TBebyzZxMrE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 11:28:43AM +0530, Kishon Vijay Abraham I wrote:
> Updated the usb_otg_hs dt data to include the *phy* and *phy-names*
> binding in order for the driver to use the new generic PHY framework.
> Also updated the Documentation to include the binding information.
> The PHY binding information can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--utPK4TBebyzZxMrE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybUZAAoJEIaOsuA1yqREe48P/ArgpPgbGGwTT4DqHdKzbwFK
i5b7S4JA8J9so9n7s1Njd1VeVO3VyIv7zUV36M5ANAgJHwR5gAslv53h9Ps14CB4
DxiLo8YSvNv+EqhD4TrL4xNKf6AWk/5MaasvnOLZyHJgVKqe5/wwMlbDN4PDIfYj
E+pfDNWIzJYM9aGfmKALS0/A05eo6LGiv+gitHyn5wwZAF8TFB6HRRa/Sjn/K3UK
H4WSg2c5K85GokwO5OEzBcqSbKeJWJknm6i0+G2JroUdgiPVfYzYPVtmp6pF2W4X
8N2FRy7+24UJvgzjtteTylzHuVrLFaUtr4YxKygKxF+tKw+lLqEtZdUR4dFG/Jis
2u+9yNpCOHGgMg1xMGjv8skx+6y/az4Kj1kFWPcewkhJ1JczgRoGSxki9/16o0OB
U8uwe+YA8EEYxxv/ATFQp4rV28AORlRov4Q9zFQcWI1wI7ArZsLNHMs+agWM7p7d
LU0ADkB+ibhpBXKNIXhpLqLCYMEWPQFfOM+inYn9qKBxy1zlqhD/lSzrp58tra92
EMwoyPYCuVJsd2FhIYrclwPrd4foCzHiFQ5vXdIMZfFMMBjWJrMiVHdjQVF7HrZh
DADgBzJfmPrOSTpM2kj9nI2y0aiTCZ4LoSJ+UIOQJOcSaq8nD6/SesXzMBWwnj8a
v3vW54JC2e/lxvnDomCw
=3kT0
-----END PGP SIGNATURE-----

--utPK4TBebyzZxMrE--
