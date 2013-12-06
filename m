Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3LFUgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:36:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47488 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3LFUgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:36:06 -0500
Date: Fri, 6 Dec 2013 14:35:23 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Porter <matt.porter@linaro.org>
Subject: Re: [PATCH 1/2] USB: gadget: s3c-hsotg: fix maxpacket size in
 s3c_hsotg_irq_enumdone
Message-ID: <20131206203523.GK21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
 <1386331425-16594-2-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVcIhgQsEzAXu06J"
Content-Disposition: inline
In-Reply-To: <1386331425-16594-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EVcIhgQsEzAXu06J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 06, 2013 at 01:03:44PM +0100, Robert Baldyga wrote:
> This patch set maximum possible maxpacket value for each speed. Previous
> values didn't allow to use maxpacket sizes greater than 64 in full speed
> and 512 in high speed, although hardware is able to handle up to 1023 in =
fs
> and 1024 in hs.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Matt, will this cause any problems for your efforts on Bcom ?

--=20
balbi

--EVcIhgQsEzAXu06J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojULAAoJEIaOsuA1yqREap8P/A90z76AwFnz95v4S2P+9dM5
Wx18GwdGiWq3LVKdOwNEQhtWmaCLKSCI7T12z8OCObgIqaR63PDzm/psMYcnF5aI
zVfixQbFBIPKYXYn1YuYgPYuth/2zurPu0s1wFSJ2g3QnElHFK9zjqfMimP7/HTZ
/dAPPXpD3pnwiHynK8Qskm8PzajpvwEjs3zdIjHWs+Qf3fdRJjKmk+1dunQ/MaZM
QorgO2FHGiY1Zk20NOceteRVIKUgcK+3InKLw34gSfK1OaaWasOuwMvPeHa6UGS+
f8o5C7uskTg1GRNdDCXS5b3t+O7qqmA9I6d0Qhsg66e772J7xitBXJeRU3NebkDW
3rEUj+dK7ZULGtIZu+/ltSndmYBWhbOrsWMAE/MlyYKBzLgVgyL5/QHiodlN1zCw
r5g6Nm3itNPi4AejmRzphefcLGzd6/BpNPKB7/gI+IFVlRT6x6CavFoG9KVOtzzE
PK8gwdBgR+jAfqNQlPEsNcSw84x00o4AcVRUMcCx333UxYrQpuvlISdC87O/pgNl
PhhyqTqCvJB0ChkK8nsMG/YuVWW7qMWSIH3vt+UoQ2PYr45/XeJLwhmNR3Ltdu+Q
q16QNd75hqRc/JYZgJfK+2mcfntUNzh4H9quEhr/6S2mpux2vzMVT2wMh5ShRpVd
H8HTsH8hnWoBdBBClAR1
=4ztE
-----END PGP SIGNATURE-----

--EVcIhgQsEzAXu06J--
