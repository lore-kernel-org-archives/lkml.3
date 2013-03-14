Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab3CNODj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:03:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39568 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab3CNODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:03:36 -0400
Date: Thu, 14 Mar 2013 16:03:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 3/6] mfd: omap-usb-host: Actually update hostconfig
Message-ID: <20130314140324.GG26080@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363083940-20050-1-git-send-email-rogerq@ti.com>
 <1363083940-20050-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Content-Disposition: inline
In-Reply-To: <1363083940-20050-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2013 at 12:25:37PM +0200, Roger Quadros wrote:
> The helper functions omap_usbhs_rev1_hostconfig()
> and omap_usbhs_rev2_hostconfig() don't write into
> the hostconfig register. Make sure that we write
> the return value into the hostconfig register.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

makes sense :-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQdisAAoJEIaOsuA1yqREZywP/jBK6J4O1fM75PGTPvrgENvr
OrSFM/YWc+pD/drAA1JavyCFTf5rxMP7lOSlynTE9qctXy9fyMbhvfnrGUo+FZmH
ei6ihNPTRYenSO5ugtc2ml9JT7GIToFH47Qi/ch2jst8wrCx9v0JmHJzk4/DhcwY
X2sLRT6Wl+M+EMDZAyTWuPwSiW0lcM1rLe9oXUbpgiVg1PMQRItJ+1DUGKjl2Gn/
AAacInWPJJwrZsTrnMSY+u+IFpHkQGMNuMNh0gpfrbvDnb2mXpZ30CiD5+2k37PP
neq3wQxruKc4ZhvCQ1BwF+AeHqop0Mx1RYr4/S8hyViWnaF2uOtAcvapB/aOdh54
bGqbtb2IAE/w0iaVx/ydWqrCmrO+C8dodtligviEd+ZkZn8VdT1aG8hBr4bfB81/
pwz/1xy7camkJdqlqO7M1So6zyexdtkb6NT5QHEKeE4nVsQp6mD5MoxrejhmovOA
hbb5ChEso7VPpvxoHR/YivjqAHzttcF3859h7Vg2V1uWUxfYjwBa0MVo+bMO1VFD
1w5RywWP3bV1+/WiuVvJk0xiqRM8vIxwwLh7Kki3WZFN1lWdjd8VcaXVvnAzAXje
Syyi+cm7yWibNduNNCANEgfHyy7kr8jfe2mq2rSF/HSi6L+tMQhEsXtBtDSeoCeI
6h1bSWi62twLm1TxW4V2
=uCzX
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
