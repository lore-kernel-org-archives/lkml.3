Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaKYOSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:18:00 -0500
Received: from sauhun.de ([89.238.76.85]:32869 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaKYOR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:17:57 -0500
Date: Tue, 25 Nov 2014 15:19:24 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
Message-ID: <20141125141924.GD1843@katana>
References: <20141124210809.GG2817@atomide.com>
 <1416867655-22232-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <1416867655-22232-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 02:20:55AM +0400, Alexander Kochetkov wrote:
> Commit 903c3859f77f9b0aace551da03267ef7a211dbc4 ("i2c: omap: implement
> workaround for handling invalid BB-bit values") introduce the error result
> in boot test fault on OMAP3530 boards
>=20
> The patch fix the error (disable i2c bus test for OMAP3530).
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Fixes: 903c3859f77f9b0aace551da03267ef7a211dbc4
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Tested-by: Tony Lindgren <tony@atomide.com>
>=20

Applied to for-next, thanks!

I'll push out this evening to make the boot tests work again. If there
is more to be investigated, either hurry up and post v3 ;) or let me
know that you need more time.


--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdI/rAAoJEBQN5MwUoCm27vwP/26YUQ12x4vab6NKhQEEca2v
YvdWWNl9E2SrI3DiaBbjY44stVpkg6OEl6lsyxUs/AqQQRfjutWyDyexyELWpPkj
NMQ2H5tPuIg6WIuo8UawRheoFumy8LnXUXCHz84J53cd8HsNyDy9+8SjNqolqMAM
t3tPeoR/atBk6JzlCuyvLZajUkfPB8VwZ1mmDfvHHwYFSzbM01D72opWJORvowPn
WwCKzgEEqa1ym0mjoIukI/NGe+4Sj3LVzZz9hUMFhdNHfcMSUdJ0I0vEEGb0nbnJ
/knCHluL7SsNtilnBathDTMYAW6YTKvnimEBxhOj+MmemVkCzCrqG2J7M4wPHwBg
qI2kfd4jezwXJeJGHJX4hMu1kDQiM6N5P9kZMOUKT+yFYaZmJPUaN3ozpjBJkzeN
H1Nos8B+ovFVP5tgBtJp1e3AePTga7BFNq2HWF4m2oUXVuITDAeReZxDV2YJYL7q
OrhCBDFrrrhAA0Ldh7l0KWb225Q2ZZKRM3NOrrWFKfuYXV7O3FtoACWS6H8K5zJ8
DGrfKO7jzTntNdacv6yWpqkEtyETnNHuE1BUF9bT14Br6FJHXuONXR11Ne83aZ3I
CHBVxa3xgYPvnmmZMSvi2IQ7Qprln5XdP1QKGlVYzSqpiFWrWOk7OjHhbSHBK/HO
4GjuVWmrBkqnWA003sCL
=zl1p
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
