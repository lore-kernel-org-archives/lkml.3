Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3GCOOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:14:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab3GCOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:14:41 -0400
Date: Wed, 3 Jul 2013 17:14:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 3/8] wlcore: remove pwr_in_suspend from platform data
Message-ID: <20130703141403.GP15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-4-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v+Mbu5iuT/5Blw/K"
Content-Disposition: inline
In-Reply-To: <1372860209-3504-4-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v+Mbu5iuT/5Blw/K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 05:03:24PM +0300, Luciano Coelho wrote:
> The pwr_in_suspend flag depends on the MMC settings which can be
> retrieved from the SDIO subsystem, so it doesn't need to be part of
> the platform data structure.  Move it to the platform device data that
> is passed from SDIO to wlcore.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--v+Mbu5iuT/5Blw/K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DGrAAoJEIaOsuA1yqREfS8P/2rrlZTd5MOYa7sI2VX2QjSD
RQa262u7GknQOq6bNZ37RrhrdfkX/PB3Omcs/3FvY529dTzlOBI+o752H4lmFPTr
EIMbk4RbGZ6s2cnDBq8YXio2YTBTrK+IM+RkU9WhlXFHSqvTi31I+N5nSyfZ7RGa
EjHS4qbVz7ydsw07a2u17Qw7lHW8bjbyJnlfJAVNOK4Rj1/8H9iRi0d6EhNqULNn
OA4RlG5YUVrW1q0Ipz34i2VYhXuv6mvA6P6jTU9eSVCjnC2J0s8Bn2pMZZDzD9XY
lSlu1ozwxW+uL7Ex8+RnnxzWqT9xgOrV/gwXq5drdJAkJSMyx75avHvbxFO5yAOr
e7BMmkY8+0r3inuZrI0Aagy6B4wTlmWnvd0SnVU98nrU5r0AXN5KYOjQwE75B3KW
r8WQVisqvqenW0+EuthoBsZt3nAZ62NdfuaVoIQ2ricDDV9/jVHefKiY+TT39wTX
YVLf/XHp9+VXWtWoVyriEEi6jzSgQhX6FPPCvhEfERoeiC64gVq6H0cYe9byiUS4
slCl9wF4hsiGk1s9PDHbz/F8J9MAgzvu0vVe7n2aql7MlEK9h+rvGrtwZyfAOCBo
UdCWvkiuS5Ag+XfhW1Ie7fstWWkz3LylNs2uLEonvkLOCqMWXzvZDKBWS2K5UCw1
wLrsPp1sLgL7B5Xj///T
=8X61
-----END PGP SIGNATURE-----

--v+Mbu5iuT/5Blw/K--
