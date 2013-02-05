Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3BEJed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:34:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41982 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab3BEJe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:34:29 -0500
Date: Tue, 5 Feb 2013 11:34:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 26/30] ARM: OMAP3: omap3stalker: Adapt to ehci-omap
 changes
Message-ID: <20130205093418.GI32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-27-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwX5Nmi7feudBrEr"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-27-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wwX5Nmi7feudBrEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:27PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 2, so provide binding information for it.
>=20
> Model RESET for HS USB Port 2 as GPIO fixed regulator and link
> it to the 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--wwX5Nmi7feudBrEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENIaAAoJEIaOsuA1yqREelgP+wd9kWrfAwVxttlEWwCugt9J
uqJ71g+qgQS3S0TP9MUAI2Ol8MV1eWMaKa/r1jWLV3zQ7fNMjAoJqhKjOXUGCv6g
caLkBIxqTLCOZ9ikTolir5W5sHNLnqd1HefyM74J+09Mw4f0rivUMr1JmBsOJy+M
qVEHFI0HPw9GGUcEkUhurlLLZ91q98PSgOzasNhaTIwPlNPg9hgvI2sGGI2a0E0f
iAoehGWHvt9d1mNPAHG4Swhvh92QzqOPCr1pYic4AncUIRjk8jkTYb+AnNIMlPOB
IKuZNAdOIB+HdNHoKqUV2h05y+mAg4YrYYnrHTkme8Bc58VUJL0m9R4JDeXym37Z
kaecpa71764qwFPrU12Ssw7u19WsgMnirzmFvSd32JW5X660bJSgYLNixCakeKRS
UUDM5/kZnJMD+9kxSUjpQocmFQHgikXFwSiiDRO50kSLZtI9T3WgNZ8OJDyigzK7
NsikUj9yn594FNVQRunj7bAygbnEtB3Xyaj21M3ZchGoiT1sbDyouvmJ6kyZAdBQ
9O3w1uoKyiiEsRPlTOlzePMjKJZqM4xFvKSRFHXhN4Ffyk/zULygeKmhRQZ9nuIu
OCCT0OaXK5iMaMIgO3W5MGv6vsSyG//UHDWZezBktUGsKhHY65bAiY5YOFUEK/zI
CLwas8RZdFXxO9kVC/yw
=V+lg
-----END PGP SIGNATURE-----

--wwX5Nmi7feudBrEr--
