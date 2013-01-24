Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3AXOFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:05:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39345 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3AXOFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:05:20 -0500
Date: Thu, 24 Jan 2013 16:05:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
Message-ID: <20130124140504.GA2609@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 24, 2013 at 03:57:03PM +0530, Venu Byravarasu wrote:
> As pointer to PHY structure can be stored in struct usb_hcd
> making use of it, to call Tegra PHY APIs.
>=20
> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
> so that to avoid dereferencing of hcd after its freed up.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> First version of patch can be found at
> http://marc.info/?l=3Dlinux-kernel&m=3D135581479020213&w=3D2. As it was n=
ot
> yet applied, sending v2 of the patch.
>=20
> delta from v1:
> Modified all Tegra PHY APIs to use standard 'structu usb_phy *' as
> their parameter instead of proprietary parameter of type 'struct tegra_us=
b_phy *'.

I would like to see those tegra-specific functions vanish from the
driver. Can that be done for v3.10 merge window ?

--=20
balbi

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAT+QAAoJEIaOsuA1yqRETrIQAJW3r4jriDtezZLp0bt4BRgQ
BFfPu01kbS+LcJUm5OILRr8cs5dv3tVvU/vCLoqwAD2ikWAq1O8p6btugue1uWjV
m1QoN2dPwwBkO8lXVLOppUYsz8xe27JjFe7uXhVD4DyJ7YXK7MwoxoaM+1PEc1TM
NqP0FSG+slIO6Fh7NdifWUlVry1Afz6h7tS57x1/udHE1rLKYeZa5cElv3CAKqVm
LhwKzC2iJJZBuWi+1Inps19Vfhp1SnJGGSIgJ08zgoNxnSvilAs5J9gYxxTyDBIS
ofgWbihVNOZUUsRvAyowge06iyoKOy1RitemUYjDeUuftzDlFWQvf/ymveXrZeWJ
wYXfeWAeZOznluuQn5n1ijlF51LhqmxyLtRwYQYojaE4+vfiDzzIiOKXzaMATk+d
OgrFFSmL/px3trGmKNJDfs6hvOPTdARSrDc3uWkCPlHJwUIGF3f0j6IQjcvGK/JT
fFkDZSK/j2enBg1RG1nb8TvfhaECJKKd0IG5CYmKsshBaLn+iH75dTz8wz0ypk9q
Jzr942fu/nGjpPTElf2NkI5U3Lce9RyqUNtG13lCuFDmmdCEQUiimBttlzDnuUDc
WpuHW4B+zD//Cig+M7Oexn73CuQrbMpKcCCYtgDE2FC80jOc/weDbfuHM498HwUF
oV5UNmnmkTSP0nYgtrdi
=GQi0
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
