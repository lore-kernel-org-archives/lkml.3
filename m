Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3GYTRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:17:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39157 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab3GYTRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:17:39 -0400
Date: Thu, 25 Jul 2013 22:17:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: <balbi@ti.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 8/9] usb: phy: tegra: Use DT helpers for phy_type
Message-ID: <20130725191734.GB26858@radagast>
Reply-To: <balbi@ti.com>
References: <20130725190023.GA26858@radagast>
 <1374779476-16025-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <1374779476-16025-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 25, 2013 at 10:11:16PM +0300, Tuomas Tynkkynen wrote:
> Use the new of_usb_get_phy_mode helper function for parsing phy_type
> from the device tree.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Here's the version with switch().

I guess you misunderstood me, I have applied your original patch,
conversion to switch is a separate patch since it has nothing to do with
use usb_of_get_phy_mode() ;-)

an interdiff between this and the previous version should be enough to
generate a patch converting to switch.

--=20
balbi

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8XnOAAoJEIaOsuA1yqREy6EP/RlqIabyzy8tkrEUsCg+v2Dr
JqNaCNU7JHvwNWD7qredlTh6ahfYqmY1gq6AxsB3V+ooXZaVIft/GUEJMxpuv7Nb
6GWcs2O6dABkwnpF2P52pRtKxjuQKHWNKP6QkZcPaprgVUIjgxfkfx53z7HPuIW8
nGDU08T/MElUfz33wGoQ9oI0eRDuIKcJGOScOed60q7jU9F18+I82kpYq9NOrCYv
Ekseg+b2qV3LXIgX9H3VrlkNM0dwRjvP5Ren9pYCrWpaoHi3k27swjPcnx3Plwdu
c2eOeKQ+/FLgpL3ga2/Si13pf1RCs4wO8Bjr+4HpfbR7tHur/tmDK1CkHIF7K7GU
H01fyxT/GbqgdU0aS5n90+AY9UbX/G6/2STM9oblA+D3F6bdFKYxO03IeAE3a1dP
KyOstBbfxW4qr4j6VYCUNEoVcknDOUocLT6jLfNUSiIJAHLQTLqLLAOSGqSzk19n
wSqYUBHgtT9j2rW17AlV6WdzMMucV3Q7bYEaHYiE79pXGZ5PoRXDDlKqXaSeeUvU
gr43wwId7p4rbqOC0M4Kpa1AtUuFYVJ+UX9gx1OBXIfo/hGePO44FLsJw5rsFWjB
LV0fI8GIbKHc5WIewBW+8ea4PksYN39lXz9tyg1PlEUl/do6DFTbGj6zhzFJEDH+
z6f/eQWstFV44bvGjb9q
=D/q1
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
