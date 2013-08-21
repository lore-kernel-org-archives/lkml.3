Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3HUKRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:17:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36797 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3HUKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:17:21 -0400
Message-ID: <52149387.4060007@pengutronix.de>
Date: Wed, 21 Aug 2013 12:16:39 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Libo Chen <libo.chen@huawei.com>
CC: wg@grandegger.com, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com
Subject: Re: [PATCH 1/2] net: can: at91_can: use platform_set_drvdata()
References: <1377080103-33872-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1377080103-33872-1-git-send-email-libo.chen@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MmrCVucN58Sg5sl5tHS3ufIQgJPw84An7"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MmrCVucN58Sg5sl5tHS3ufIQgJPw84An7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/21/2013 12:15 PM, Libo Chen wrote:
> Use the wrapper functions for getting and setting the driver data using=

> platform_device instead of using dev_set_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
>=20
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

tnx, applied.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--MmrCVucN58Sg5sl5tHS3ufIQgJPw84An7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlIUk4cACgkQjTAFq1RaXHOa2gCcDah9fhIKLkT2x09Z3UvnnzlQ
A48An1o+9xjAdA/sp+RZffnzuruNLuP1
=HP9z
-----END PGP SIGNATURE-----

--MmrCVucN58Sg5sl5tHS3ufIQgJPw84An7--
