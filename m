Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3AVLAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:00:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35400 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3AVLAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:00:49 -0500
Date: Tue, 22 Jan 2013 13:00:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: moving all PHY API definitions to usb/phy
 directory
Message-ID: <20130122110038.GA685@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358852210-27814-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1358852210-27814-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Tue, Jan 22, 2013 at 04:26:50PM +0530, Venu Byravarasu wrote:
> As drivers/usb/otg/otg.c contains most of the PHY related APIs
> which are not OTG specific, moving them to more logical place
> under driver/usb/phy.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/usb/otg/otg.c    |  184 ----------------------------------------=
------
>  drivers/usb/phy/Makefile |    1 +

missed git add of the new file, but hey, let's call it phy.c and place
it on drivers/usb/phy/phy.c

Also, you will have to rebase on top of Kishon's latest work which I'll
apply first.

--=20
balbi

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/nFWAAoJEIaOsuA1yqRE2E0P/j8oTsRutkXUFnJL3p/4dxIo
eYYRGJ1WeClnMQG3HLllbKxsW1KRx4xREz28E44X2pvF/MvtpKg8cR7/yv1yRxGm
T9j8oKrVLot/bKV9Hk2beOKVvFtSaxLQSCCiAMT+Gd4CvqQly8YiKb58++L8+RK0
w0BQ08j5pg0NTMF/hO2dK5jLatsI+EwyRJW53lrN2vJcesbBQB8eAjsfjZ6JBJOp
OAsl/fSqTCzS2SRGfnEE8UO+F3ymIXWW1v4o41BCV/pTS/k1nR/6QOcAB91CFTQ1
h+Tn9Y3QI9B5g1+hF/6Wh0bmaWasB+OR8CShJJBIIFTEV6z665Q4iQVmDQ8ym5Iv
Dg25Hq6KYNgTPEBIFPh/thGI9W5wMGoHx7826U0HlniQEa77X5KPyq/HLkiY/PpX
eehSw1kli5ZcfIG7HvVx8Ww6t68ikJt8+8l8k4LeGS+hCa/SrNkrHSAfncKOsqrt
gcsoo1aOT/vyVHx79BVAa/pAJOYHBIuKgoZUieniV2XqyuDtcsufPiSHXkLFi/fc
zgHgr/k1as0hoqd7WRexjctEeR/H5Cctt5N5NMbVNjDAZEOVQhFWNtMMGd57EhL8
r5IWKdIE/lRA7VmcsUBfK6BCMM9EF6WqFjNvEtrxkxPPnhAKjnY2ZYzeX9w7rhnO
4IjFOp2KdAVZKbNkNBnd
=Nu3K
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
