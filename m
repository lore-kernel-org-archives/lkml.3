Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3AYHoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:44:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52606 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3AYHoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:44:03 -0500
Date: Fri, 25 Jan 2013 09:43:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 1/8] usb: otg: palmas-usb: make palmas-usb as a
 comparator driver
Message-ID: <20130125074339.GD15886@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359083551-8524-1-git-send-email-kishon@ti.com>
 <1359083551-8524-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <1359083551-8524-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 25, 2013 at 08:42:24AM +0530, Kishon Vijay Abraham I wrote:
> palmas-usb is made as a comparator driver to omap usb2 phy, so that
> omap usb can make use of palmas for srp and also to set vbus.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

doesn't apply. palmas-usb isn't in mainline

--=20
balbi

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAjerAAoJEIaOsuA1yqRExq8P/3U+uIqSa8HbY9KxYnlJMCjp
M5H+fZJCKhfqIkgFZdVNugU0nMMMxj2Wnw8zZWdPHe4ueK4zta5ghqceacfWAF2B
UFS7dB6H//lX4puE1svPvpXs0vujtGhY1fgZGQoMQ7h9PZQ573QXZpvE+gJbO9iP
iiy5IuCe3R2Q2KMiRYgt5wGcRTDWLei58XIg6mAQ4phboMLNWZQiV1azBsGImq7b
Q7ukw8DwybMt0/WZrRe67zxz0XpZxrk23VUXJdUH343DTkOh9x6trWiXY8Up+tpE
pC1KazTgcohK5dzF6W8+eKW5oPLKizeSVFte/bnz8S0wB6HEcpaAiH4X8tuwv2Kh
1ecmlNpZNSyAGFzkF0fo+Nnb13ZF5MPsd8AUiYMWdA61ovnXMHUxirBz7T8baIBN
ZsVhLWd+j+XaYWWfICO1Ju0wFBYilLStfP4d89MlzodV3TMfOs9YvhIs2Crr3a17
uMjbWzQ5yE/7mjBG/pwJMqVJEE43BWA5/Nxqs/n9U5Y1h8BmgTJizbGggJ5mFNJz
M54TqOXfUaNPZQPu05mBVwUkp/eQsSwBSEiNoDZznWDDkcBj86zXjDDx0CfJ1/Kv
aHLZWJaRGqXJmeVU5C0v/p3eNQ2lQrWC1+tqMqD7zU6SLW0HeAbbcL6P/GUOYmzj
nt9lwBw07woeT2wdwUvd
=Leb5
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
