Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaCXOeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:34:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50903 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaCXOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:34:24 -0400
Message-ID: <53304266.2060200@pengutronix.de>
Date: Mon, 24 Mar 2014 15:34:14 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Bjorn Van Tilt <bjorn.vantilt@gmail.com>, krumboeck@universalnet.at,
        wg@grandegger.com, linux-can@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH: 3.11] usb_8dev: Fix memory leak in usb_8dev_start_xmit
References: <CAMEA=P1AaDL94S8kaep-F012WAseimAyB7ME11Qzd0UMbp-BGg@mail.gmail.com>
In-Reply-To: <CAMEA=P1AaDL94S8kaep-F012WAseimAyB7ME11Qzd0UMbp-BGg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4BxXFMgP27k7aG9M8lretMcCKXEeH2dpx"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4BxXFMgP27k7aG9M8lretMcCKXEeH2dpx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/24/2014 03:13 PM, Bjorn Van Tilt wrote:
> Fixed a memory leak when an error occurred in the transmit function.
> In the error handling the urb wasn't freed before returning. There was
> also a call to the usb_unanchor_urb() function but the urb wasn't
> anchored.
>=20
> Signed-off-by: Bjorn Van Tilt <bjorn.vantilt@gmail.com>

Applied to the can tree.

Tnx,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--4BxXFMgP27k7aG9M8lretMcCKXEeH2dpx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMwQmYACgkQjTAFq1RaXHPalwCdHKXhTEQdgpj9Wt3mzFxrmESf
9BQAnRoWQ9w4Syma/bm99ViKmN/E2vGc
=KnL4
-----END PGP SIGNATURE-----

--4BxXFMgP27k7aG9M8lretMcCKXEeH2dpx--
