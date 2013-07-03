Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3GCOTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:19:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51837 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab3GCOTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:19:19 -0400
Date: Wed, 3 Jul 2013 17:18:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 5/8] wlcore: add initial device tree support to the
 sdio module
Message-ID: <20130703141846.GR15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-6-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/Dpz40iF3jpiHxF"
Content-Disposition: inline
In-Reply-To: <1372860209-3504-6-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2/Dpz40iF3jpiHxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 05:03:26PM +0300, Luciano Coelho wrote:
> If platform data is not available, try to get the required information
> from the device tree.  Register an OF match table and parse the
> appropriate device tree nodes.
>=20
> Parse interrupt property only, for now.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--2/Dpz40iF3jpiHxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DLGAAoJEIaOsuA1yqREDPQP/2DcHPHnJZj0dS/cD/PZKrWV
jkk01tJW39FMkPrKT51VhTEG4fS0twhCi9Hp4cxRilI1/A3X7HWtcUK1XgwDrtQO
DgnWmwaFlQEo5MtX9vFN0PjMg6Jdk57z9Ou+2z/SNFreaMAZOR0Oec/pf+WkjqlV
nr5KIGuPvZ+xNSxRKDN7y1JwaQuc1EXR1ljKlHXUUU0Run6dQ2rSvk//NJluY1hK
Kn5upbJjny3zv+jGO3XGVQ2yru9Sexs5MV1LtiD8hewaI6+ZpSgLdvdOVVZCepKA
Eoj3ewN7/YxHBZvdE8VP1LwBwFuvBpQxGU6A52IMQWEBtR6TXDduGq4FMxroHvmn
geLJ9IC76jAZ+BvLB5KaZFIlZRScVW9bunYOlTXk8SVkOmHHNPL0QNOy7//fuDs3
S/b59jLEUPGl5IPj0LthTKHAUAAoceNddic6FmfuiAtnQWY0nyumUF8lu+dZgr7K
SdcEFLbNaNY9lX5BnKn0Gn/Lv77NwFPTpyv9lU9ni39edKG/uKkvGVxfOuT44VMf
TD8LJsvUzEDhFATsrsMe229ONHsPZy4zuJLh70LaEbDVmzclsiwPi4g2nVTnHB1M
exJ1ar8LQySnEDMM+EE30avz3FCe+349OGffH30WI2e+I+VI2RUGesN7jqpmvDcl
+OKeDn8wWW9uCcK4Rs1N
=mklH
-----END PGP SIGNATURE-----

--2/Dpz40iF3jpiHxF--
