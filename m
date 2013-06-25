Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3FYPVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:21:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44220 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab3FYPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:21:51 -0400
Date: Tue, 25 Jun 2013 18:21:05 +0300
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
Subject: Re: [PATCH v8 8/8] usb: phy: twl4030-usb: remove *set_suspend* and
 *phy_init* ops
Message-ID: <20130625152105.GM21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
 <1372139926-3719-9-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5V5c01chtBAiSHoy"
Content-Disposition: inline
In-Reply-To: <1372139926-3719-9-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5V5c01chtBAiSHoy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 11:28:46AM +0530, Kishon Vijay Abraham I wrote:
> Now that twl4030-usb is adapted to the new generic PHY framework,
> *set_suspend* and *phy_init* ops can be removed from twl4030-usb driver.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--5V5c01chtBAiSHoy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybVhAAoJEIaOsuA1yqREAxIQAJYWoDFBZnbz+ZyQAFyskF64
j4wMKOZo/xDbRGl8UFvzHvesGvccUfEXKtGcdxCu0boL3H/KOwUmjJgWP2LZ0KKB
4P34Kh7XFDh1on6xhfDvkO10ca2XU6vcAauJfWUKgon7fi/h/61u/4SeJn4fWaEJ
qX0sBYFQkpLLoeqr3S9Gl1+hGZxJ40CwdE2BpOQiD2mUuT4QZ6xI0ilssJYkc8mJ
XCTfiEgy6J1kZGd1il/Vng/nfSl8VRpAKP9I/BciOjtBR01K6GgpJP7ygG0+GW+q
7PZry9RwyjVSa/gMqoaLBcFDFU4SHXLgdIRj2DZu1oDxSFZHDtdQc5cpSBxbh1Qy
z8cf2vbyx0sJyfLnFw/dnLzBNqBX/4tjk7Dd990RmDOvcIlalie85KCx1JFIo32W
bgbTOn9W+3/TG1/cvPVXmOeNsIHwRpXFYKNDcyknksUZhPfvzYQ7lYnN93GK/Eyj
uRDw+1smwFVRZT4Sfpr4OU8z2s2kJrd8ax8igMNCl2weg2soeSoXB2/Mb0eKiWq8
bIgDJT5q+m2winHOD34eS63g0981aojHeAtKdzfRvm7sh7lZ25Jn5krs+NWZK73N
jaAOgA+Y43ZSMgbtz/aiet3RqXHGUR/AATDTS8IPpRqF8iyP4Azy/BU68wFPiI/z
Zrh0V4bgnUxeHSTgYk04
=JY2j
-----END PGP SIGNATURE-----

--5V5c01chtBAiSHoy--
