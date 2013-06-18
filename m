Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3FRJte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:49:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43226 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3FRJtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:49:31 -0400
Date: Tue, 18 Jun 2013 12:47:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 9/9] usb: phy: twl4030-usb: remove *set_suspend* and
 *phy_init* ops
Message-ID: <20130618094736.GX5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-10-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9dSeJxMIUBTi9Do"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-10-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R9dSeJxMIUBTi9Do
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 02:13:59PM +0530, Kishon Vijay Abraham I wrote:
> Now that twl4030-usb is adapted to the new generic PHY framework,
> *set_suspend* and *phy_init* ops can be removed from twl4030-usb driver.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--R9dSeJxMIUBTi9Do
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCy4AAoJEIaOsuA1yqREHocP/i2OqyGLQ7KK4AWerNk5ViBX
HIZcxRs+sQCTWBUcP2I3MS/V+EhTTgeRo72ij3UXJ3LFKWrGndRvc42DF144twCl
xElvVMC4w4ETiEbrb/JQqPp3M8e0fvS73Tvz3nx/PGs3kgAsvV/DK/jdJ7iyTEiG
zejLhTm8XBigEOqJ1SDKGk94FxYJ7EP6zKi7fEEjxPkqo80sH1vQceH/WZ/u9LIn
l2mfqRVK9l4IoSAfm7QIg6YzXiHhnvuRlLV1vpWXXO891WpQOb+2vKMVxVxPybER
v++uCAYSentfZ8Fh3/5zY21GmTMX9/JeorD7GweyHcLlFRd2Nqarr1O1EMuaDZ1I
JnGrG0MHasUVCNqX1Yy+ewscEWcd9YoZpnt7ZGc0p5dz7dNrNKJ34hv543xg6VUQ
LxGtvG94RPxhbZZtJBNR6YF2vrzmMgNDdo+9qrNF8c8HHjF9loOh5JTprJl4Nswj
rJh1afEWyPtzBLXRTJo7KRxx1fLngdu49IiqroU7fB6HzjnG0QIt6QZvisDoA8mR
JrrYidNMUSDC0VAwv9gDX+TsaL9HgDn6na6rcOmsQFuO6GqAOKD3OWiyGccXkyLg
AN/H8BFstc8KwlO1TaBARG2te4NQ2RTBJnTS6VYZNBvWFZp/6ApPj0FQafZKWw5U
ZSn3NVCS0TLYbZpjshDS
=wIeZ
-----END PGP SIGNATURE-----

--R9dSeJxMIUBTi9Do--
