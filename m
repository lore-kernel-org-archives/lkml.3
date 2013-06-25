Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FYPTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:19:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43858 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3FYPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:19:21 -0400
Date: Tue, 25 Jun 2013 18:18:34 +0300
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
Subject: Re: [PATCH v8 2/8] usb: phy: omap-usb2: use the new generic PHY
 framework
Message-ID: <20130625151834.GG21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
 <1372139926-3719-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhYGnrYv1PEJ5gA2"
Content-Disposition: inline
In-Reply-To: <1372139926-3719-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nhYGnrYv1PEJ5gA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 11:28:40AM +0530, Kishon Vijay Abraham I wrote:
> Used the generic PHY framework API to create the PHY. Now the power off a=
nd
> power on are done in omap_usb_power_off and omap_usb_power_on respectivel=
y.
>=20
> However using the old USB PHY library cannot be completely removed
> because OTG is intertwined with PHY and moving to the new framework
> will break OTG. Once we have a separate OTG state machine, we
> can get rid of the USB PHY library.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--nhYGnrYv1PEJ5gA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybTKAAoJEIaOsuA1yqREXrwQAKNV7K3cgLiQnugHivCwxqnZ
wZo9YsTm+a8SkRCXjOaNd5YV1Ky6GwB1nUl4dDCWKXxrFAD3p8/eKAE+Zqzmuyh1
fQcKk7JcYYE+hyOrUSExNfS1y/P1yDmbH84YMYUoLwVV2hrrthQb/uNHzrCWzbOF
kE9i0otmyQflWx8Dum64ZlWcbE3dem/pO2x5sNmbOEtrnQg32fLjf43vr2jZWUVJ
BgMftSccdY3fu5Xl2+HOZhaIYFioTrtP4wPuEHK8OGXJZKl83Rj3WBXqXJ82k2R8
ER7sosZsO1/YcewPFf+Nid/Y13wTmuUiLJFudoG4XcDVaWJ/dXLgr6LThTMtbgAs
HpUD3F2uqbzPGRanaHjDRB9BtEMhX7aKtQIXiCpBj8Bfrxx1TSdC0khHuDLm3GSG
gd1RWItv7/4I9OmbeWGDVe4Kw8FRklkVyDwNMF+zEOAxoo5keUsy8VZVQf1aLDy/
r8eK8ooBMmaYlVmo0IlOojdKpMUi3skKvUUiJ9OUHD9YLoYUgeEkAEKpoC4//3Mu
OP1hvjyO05Y5yPOrdxOSLg7BxAlVhGKmcdL5g/ogCH/iDC6x4j7grC51wCFZHKiH
qDgfwWcMtjUs86GNUCtw3Qt6onlFGrBVfDiZB+8uQjaaRm6ieQMAq3xoQDu6uOUT
paEYiTTFMbEoocV+BelQ
=lRHp
-----END PGP SIGNATURE-----

--nhYGnrYv1PEJ5gA2--
