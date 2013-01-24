Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3AXRKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:10:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39192 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3AXRKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:10:34 -0500
Date: Thu, 24 Jan 2013 19:10:19 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <balbi@ti.com>, Venu Byravarasu <vbyravarasu@nvidia.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
Message-ID: <20130124171019.GI4424@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
 <20130124140504.GA2609@arwen.pp.htv.fi>
 <510167DD.3090001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v2/QI0iRXglpx0hK"
Content-Disposition: inline
In-Reply-To: <510167DD.3090001@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 08:57:01AM -0800, Stephen Warren wrote:
> On 01/24/2013 06:05 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Jan 24, 2013 at 03:57:03PM +0530, Venu Byravarasu wrote:
> >> As pointer to PHY structure can be stored in struct usb_hcd=20
> >> making use of it, to call Tegra PHY APIs.
> >>=20
> >> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(), so
> >> that to avoid dereferencing of hcd after its freed up.
> >>=20
> >> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com> --- First
> >> version of patch can be found at=20
> >> http://marc.info/?l=3Dlinux-kernel&m=3D135581479020213&w=3D2. As it was
> >> not yet applied, sending v2 of the patch.
> >>=20
> >> delta from v1: Modified all Tegra PHY APIs to use standard
> >> 'structu usb_phy *' as their parameter instead of proprietary
> >> parameter of type 'struct tegra_usb_phy *'.
> >=20
> > I would like to see those tegra-specific functions vanish from the=20
> > driver. Can that be done for v3.10 merge window ?
>=20
> Felipe, I assume that means you're OK with me taking this patch for
> 3.9 then?

right,

Acked-by: Felipe Balbi <balbi@ti.com>

But I need to see those vanish on v3.10 ;-)

--=20
balbi

--v2/QI0iRXglpx0hK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAWr7AAoJEIaOsuA1yqREkdYP/ixiwqdtRfjze5M1F5j+rFYX
Katmr8mf8QckWUPpsHW5zUGiJn1AYMteF0eYKtJhraqKSR6s0u60WhLQLQInffQu
Ilq451lzfm5hc3t4fYGlQepScnAnj+ELDG17llAELihhA5VKb7j0C+zs4OQPnPe2
ik7GojE8c5detNw40CXwKy0LD/9RfgEl/eFkj5hQhpAq1RREaWfZN1WJtB1U1MRT
sQbPXQ3unVcQJgWZkiTS6J6m8FN9vShb8kKtOUepP+PHxxo72nZhOYk7kBjVHvQI
wvCI9WcBSBmbvOy2CAHyi6k26kVSkCnsz7q0xenuTV7nY89gR7oqMfzn/JeGV9Ch
ukeF887Y6bOOUs32V8diMHVgrdwZ8B7jslC53Mjp4dsWIylsJACX8eqbSEcAMWG6
cjEaoDTw2AmXy4VIA7EqVfLQFN5Mq6I2ok5ZuqW5bFumFB2Cflu8uNvFPQEiIvt/
vzHIAd3OkYyWz4doDe4Zb0MHHm4rMnjBo1w2vxXH761NpaDTcynO1KJxw95POruP
V3FAtU2RX7pJZvAIw242RI7TLjuMUy0fmQdizXNbrEHqM6mrcOE4CV+kZW0JbyTi
hgoxKp6Yf+S4omnyTtiSXJlOwpcGteZa5rg7KGbAny1D2PgvMLSkfbtd+3uUHK9H
iY3ZPHpx6ApK31QWJeVE
=LcEV
-----END PGP SIGNATURE-----

--v2/QI0iRXglpx0hK--
