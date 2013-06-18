Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3FRJtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:49:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43200 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3FRJtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:49:21 -0400
Date: Tue, 18 Jun 2013 12:47:26 +0300
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
Subject: Re: [PATCH v7 8/9] usb: phy: omap-usb2: remove *set_suspend*
 callback from omap-usb2
Message-ID: <20130618094726.GW5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-9-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2DJuma0xDHN2clgl"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-9-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2DJuma0xDHN2clgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 02:13:58PM +0530, Kishon Vijay Abraham I wrote:
> Now that omap-usb2 is adapted to the new generic PHY framework,
> *set_suspend* ops can be removed from omap-usb2 driver.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--2DJuma0xDHN2clgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCyuAAoJEIaOsuA1yqREAmIP/21dU0ZmYnIQ7Ms4NLoYsJwm
JnbwFUOyo4qM+h7jvVZ8Ip4v7shUO6KJcEUQ9tZuFns346Ft1t24c1roznmj4ZSz
BAr0I5DkPDU1C6aASJgcWCawy3Mpy/m0e7YgQLvtB98BKKRYdVZUxMn/iE43xb5t
gjex/krHQ7cLTViHHapAb7ZfUr5e7GiZmBRNC7cB1Rl6BzsizlNeKaN11SRtP5DB
5eRcN2ZU3egP5auspS+MaN+sb+c88+Eb3JBwdMm1eMlvFx6IqD4R6ALG38rrNCNg
Xb10AN/Bh4QINbS+RpcJx2KguCVqq0a2SJlcLYV7q9/lW9f/Wq8Syu93g7UcS24F
gYwsqHRvV77YkewgAQ8bUKg/xSLBJ3eKl1aN0oEm6K18dis6aJKWwVIWiMLIxLAs
72V0bFKqpI7WQwKu10LTQx15AhuaKGwxbSnmE11kV/SBhMZ1l0qay2hggCiuQjX6
8rgzEdqnfHpfs2F21hRpWqJ+Jxk3GeSEfGBC5HQajMU+GBix/zNIpBjJepkQLDFn
ClGB2z1PjwH8AIlFDWT1p/o2avS6+6zn6YjiKg90aHv6H/by783Hhn+Jn2mcMMBY
EYge4q7ief5v8Zjm/zKqiEchicfZttWmQKlJ+boSE+buSwzzBEoEXr/7yeTOV2sK
yCHz/GcPB5cKVTIcAKYb
=2EsM
-----END PGP SIGNATURE-----

--2DJuma0xDHN2clgl--
