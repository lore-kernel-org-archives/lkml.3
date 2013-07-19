Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377Ab3GSMyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:54:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52306 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353Ab3GSMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:54:53 -0400
Message-ID: <51E93704.8010208@pengutronix.de>
Date: Fri, 19 Jul 2013 14:54:28 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Bernd Krumboeck <krumboeck@universalnet.at>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: usb_8dev: fix urb leak on failure path in usb_8dev_start()
References: <1374096033-28981-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1374096033-28981-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2DVGJUTWSQJWSHLSWPGSO"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2DVGJUTWSQJWSHLSWPGSO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/17/2013 11:20 PM, Alexey Khoroshilov wrote:
> If usb_8dev_start() fails to submit urb,
> it unanchors the urb but forgets to free it.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks, added to can/fixes-for-3.11

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2DVGJUTWSQJWSHLSWPGSO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlHpNwUACgkQjTAFq1RaXHMPEQCfS4rpvy1qOf+x5FkrJl11uN/3
1SMAoIwF5db06bhxA3jRcISZDjnQq+yg
=34Hf
-----END PGP SIGNATURE-----

------enig2DVGJUTWSQJWSHLSWPGSO--
