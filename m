Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab3E1Rhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:37:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43977 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784Ab3E1Rhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:37:34 -0400
Date: Tue, 28 May 2013 20:35:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <george.cherian@ti.com>, <sameo@linux.intel.com>
Subject: Re: [PATCH 0/3] palmas usb driver
Message-ID: <20130528173554.GD15794@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <1369405896-30246-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2013 at 08:01:33PM +0530, Kishon Vijay Abraham I wrote:
> This patch series adds driver for palmas usb which is used to detect
> attach/detach events of usb device and usb host.
>=20
> [PATCH v5 2/3] extcon: Palmas Extcon Driver which was sent previously
> is added in this patch series itself. The revision history is added
> in the patch comments section.
>=20
> A checkpatch warning "WARNING: static const char * array should
> probably be static const char * const"is ignored since it introduces a
> compilation warning.
>=20
> Graeme Gregory (2):
>   drivers: regulator: palmas: add an API to set/clear the switch bit on
>     SMPS10
>   extcon: Palmas Extcon Driver
>=20
> Kishon Vijay Abraham I (1):
>   usb: dwc3: use extcon fwrk to receive connect/disconnect notification


There were some comments to this series, what will happen with it ? Any
new versions coming ?

--=20
balbi

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpOr6AAoJEIaOsuA1yqREfcoP/iObUJAcLsYrmg7OaERWUh8p
M8lHfHbyXIse62fAu9yIWyga1NTF3+uAdS8mzeEx/krWLm4sZwOWwoO6mvXyK7+O
k2nMeCEWSkIOzyrhAkpgiIFyUYvJvLta3GDlY3XSOl/SWYrGhR87wXiLOqQeA4N4
DL0WQ+/CoCBV8UH5rxPWdS1bTukmcbgWtwkX1NedQlaiaZ0oiVMl9ydJ5duZ0H1A
fphi3yq8l8hlTBVF+CR30H3v7xPosr3uBea4+YQY5tuB0ASX80tLBPlUicq3fjia
rf4bbId86nlFFEllXiBSmnIdN21q7mv0Ncmowu5HdhUar1iX4vWJdvc6EA/w9CtA
7tsSl913YViWk+LQbT15h6Imb7BbtXvodh3zTL6ceG+KHHtbLadGliJ1se3+y+Yl
sBGooYjMfZdGNdgusU7kSCgnA1VH6tp8xi3Y/OxvQA8nLu92QFLctpHalrudntu3
V6SX9m8S53ptvFUDnPQmOThQRWjMFzsBwYFmIDE7QegO4pNmGnGbS2wEVGgnMNUD
+6JBdsQthBL31IfVjjBf2eL+pqhd5Q5bXwjR1Gi6cabWEu0lhMdNi/7CusVBLSg0
oEF+77gDaf9Cs/+InwaNCHIPppZPJB6U+L+9i1KgvM3vMBhGJkCs0TVhfPULEWNk
NPpXGGg7Qt+Bfuqcz2bD
=kfuR
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
