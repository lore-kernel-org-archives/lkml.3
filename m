Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3KNRAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:00:50 -0500
Received: from sauhun.de ([89.238.76.85]:46858 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab3KNRAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:00:41 -0500
Date: Thu, 14 Nov 2013 18:00:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: srinivas.kandagatla@st.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com
Subject: Re: [PATCH v6 1/4] i2c: busses: i2c-st: Add ST I2C controller
Message-ID: <20131114170026.GA11022@katana>
References: <1383726315-27534-1-git-send-email-maxime.coquelin@st.com>
 <1383726315-27534-2-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1383726315-27534-2-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 06, 2013 at 09:25:12AM +0100, Maxime COQUELIN wrote:
> This patch adds support to SSC (Synchronous Serial Controller)
> I2C driver. This IP also supports SPI protocol, but this is not
> the aim of this driver.
>=20
> This IP is embedded in all ST SoCs for Set-top box platorms, and
> supports I2C Standard and Fast modes.
>=20
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Applied to for-next, thanks!


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJShQGqAAoJEBQN5MwUoCm2SCMP/3HI6SSjFtrYRq1xwkMg2T1E
VObiP9YJI3LNUtfCRp/eIfZrcvRYgJ6Iju3g12ww4eU1aHwDe8UFSYv8XooeosgA
fJNPEJduVesX6gPZT5Ji5gWMxYkP20BsQG8tSKC5211oGfcMCklo2896LqGFUHjG
8rMGVoKc1/GdzNEoFQbphelQLo5D5P0haSgpRWh79sON6mb+PY1+WgKoeD6GXCOR
Rx+0iCcvtykfgxlNa0vOkVMtCfjM9vOXS4ueo5q10jSuk6Z9R7pRpy+8hjCWHcnm
KVFFs9RaR0Iz8KInsLzbDNnGs98HO+2KOqaVteyc8POox9EpB1In4OIxG6bzBOli
41MHkxtMDw+HiCH2BhlQHjJRS1nie5yh+NKR4dxCsUo4VL7M8uEJEMoMnIQEHaWK
ZRF5zCUHBa2yfpD6ltplnOFgm2MoErzszMIvGF/C4i/9md3UiVppAwaY5Z+fNSKD
M2OZexTIISJS1wJc6bHPgLuptYMWy6vXsCBW0KszZLb8E2aOc6ODdDnEJ0vdq7Ot
mHWZwjD2X8JFeUwK29J7jHe1ZwWR/c6BCLeA/o6VDYosmVIQGjaqjmB9YMy8Uwr9
1B7FO1uugAzm7CyoHN/FjddBIjFPc9CcnjE+CmYvWKmR5Rl+hfju1e4b3YTeJLdZ
xpf9EAF8HPSoF2FViZM7
=2wDJ
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
