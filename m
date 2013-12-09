Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054Ab3LIKqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:46:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46211 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760281Ab3LIKqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:46:12 -0500
Message-ID: <52A59F67.7060008@pengutronix.de>
Date: Mon, 09 Dec 2013 11:45:59 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: ems_usb: fix urb leaks on failure paths
References: <1386371435-17597-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1386371435-17597-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8x4v4XrLHekBw42bbav4o8D45lMNw3pRf"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8x4v4XrLHekBw42bbav4o8D45lMNw3pRf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/07/2013 12:10 AM, Alexey Khoroshilov wrote:
> There are a couple failure paths where urb leaks.
> Is spare code within ems_usb_start_xmit(),
> usb_free_urb() should be used to deallocate urb instead of usb_unanchor=
_urb().
> In ems_usb_start() there is no usb_free_urb() if usb_submit_urb() fails=
=2E
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied to the can-tree.

Thx, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--8x4v4XrLHekBw42bbav4o8D45lMNw3pRf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlKln2cACgkQjTAFq1RaXHP1+QCdHK4Lx9tQ2zf25u2PnqGQeo9y
pswAnRTHbjBrmdE/ducyCI1bIp/htdvN
=arqc
-----END PGP SIGNATURE-----

--8x4v4XrLHekBw42bbav4o8D45lMNw3pRf--
