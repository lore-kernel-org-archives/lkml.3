Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3DWQM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:12:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51290 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3DWQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:12:57 -0400
Date: Tue, 23 Apr 2013 19:12:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: phy core cannot yet be a module
Message-ID: <20130423161225.GH15177@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
 <1366732475-479886-2-git-send-email-arnd@arndb.de>
 <20130423160759.GF15177@arwen.pp.htv.fi>
 <201304231811.35692.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wv56KCa6/aA7yLgk"
Content-Disposition: inline
In-Reply-To: <201304231811.35692.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wv56KCa6/aA7yLgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 23, 2013 at 06:11:35PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 April 2013, Felipe Balbi wrote:
> > looks like this is the only way, indeed. Do you need on the merge window
> > on can this wait until -rc1 ? I just sent a pull request to Greg with
> > urgent fixes for the merge window.
> >=20
> > Greg, if you want to take this one as a patch, go for it:
> >=20
> > Acked-by: Felipe Balbi <balbi@ti.com>
>=20
> It's not relevant for real-life scenarios, it's fine as long as this
> makes it into 3.10.

sure, I can take this on -rc1 then.

--=20
balbi

--wv56KCa6/aA7yLgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdrLpAAoJEIaOsuA1yqRE6XsQAIqrBSMuQnR+hUsKv7Nd4cp/
o5DGebJn39uwy0IMkDiQdhjVau9CKQOG5vGSRPiA+yibNJ5tbSnvW/z0v4Mj7w4k
gzlBNbpXI78do+6cJ3hoSM+hhNGKvED+AmC5FyDtOlIn4nCITbisYKO4NYbYGE32
94hrvCSWlWJxpzisDI9QJ3GS1j6Wfrh0j9HmeWidRk44V9ihh9B5sD1CqxCIs0ee
8oq7180kPBmoG77rNxvYuzKwHbQFfiBxVlF2SNSsk5fUAPXRDmpeo0mLw2hAjNMj
wPzLoLF6ibRbFOQY5ZYODGHcX6M3nso/xkGkrZoQE/kTVSPwm5e5GwlXVUISdD7M
+EJuK/pHrHBSVqzYGQu6j+UYGHnF3cuxoxJRKBReIFL/XkVjnzQYag+boVTCqFJt
LrKtRYZHGXbCQAupeY6dD2ot5DlCJUm5SkEPEZRIwUMthGuhCaewloGeulLtCaZ/
Joduh67dBCDfga6sXjnEml8RrHieDAujGsiRIrjmd/dLIN50LhamalHyxIrJIzkC
TxBv+BGgdEtZl043PWVtuPEjPP7FFrBNOuU3VEC/IW1bHBAKZp5mppfVciMIQwwM
iz4gtigrQSbTuBoCHvFYYdEDIjqUtoVxQNk1plQYpHsXjZeMDsYPUNzHSb6EOHyh
mat09TgCcdn2izCyUJ3Y
=Nvyk
-----END PGP SIGNATURE-----

--wv56KCa6/aA7yLgk--
