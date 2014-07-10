Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaGJNkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:40:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56409 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaGJNkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:40:39 -0400
Date: Thu, 10 Jul 2014 08:40:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: move the OTG state from the USB PHY to the OTG
 structure
Message-ID: <20140710134023.GJ15340@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Content-Disposition: inline
In-Reply-To: <1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 12:17:13PM +0200, Antoine T=E9nart wrote:
> Before using the PHY framework instead of the USB PHY one, we need to
> move the OTG state into another place, since it won't be available when
> USB PHY isn't used. This patch moves the OTG state into the OTG
> structure, and makes all the needed modifications in the drivers
> using the OTG state.
>=20
> Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>

This looks good to me. I'm interested in what will be the best way to
merge this series :-)

--=20
balbi

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvpfHAAoJEIaOsuA1yqRE9UkQAJx5JdnmZdYN44rY8viUXQz6
62jJ5ETzn6z4ty2GudnuxvJNRX4zGCumHU+2o3I7iCw856juqdC/Na9SafKhKdDq
NoS5Z15AOfjA5b26/OuvOh2+/i95qyZWIe4Aph+CX16pBaJQHe9l+1Reky9F6l0O
p++ugF0SGXp2pLidjLx6wxrH7sQNQKIEMZtVDMFP6FoHGKrhGp+Ov2A1vg6jw1JS
UB3e6bu++rUIerT8IHrlym1/xfSaN5sg42QhQfd0EviakgkxdMtdzUS+zsAgChvC
zYbfiC6nFYSqU7F99ky7DaGa/6RLHkWD+OudHABkqHUMJL4Bw3onktGVH2B0zM7o
xY2u+n4NQtzAqnKE6GF+Ua5Fk6MpY3w1R2NsPuXZkmV28Tve+gnaGSgM9tFolYz2
F68c9m85aXPJhQnSx3EfSYtH/21JD8ZgqWH0ZHLMCarioWJEy5Wfyoe34tvngBHo
xPQ2tGhiofhJ2E4vdTQOTxqQsKRIRorVV46Nai80x0Lc08Mi9NuTCNsTI9Gj6haW
XMlaijGrVYhZn0tRWSWGk869EPq6Q2drBz6mbLuUuyvOVypkR5PDjs6ugBmumi58
Oo1Cw/XQqWFy2U6BSqaLJY/XYavFCm5AbTk6Jj7opQIX2a0mm1C0iR0pSPEhWCKg
t4rY8/Sc94eZnpBOzZug
=cTiI
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
