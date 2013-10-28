Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3J1JIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:08:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3J1JIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:08:16 -0400
Message-ID: <526E2973.6090905@pengutronix.de>
Date: Mon, 28 Oct 2013 10:08:03 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Markus Pargmann <mpa@pengutronix.de>
CC: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] can: c_can: Handle lost message before EOB
References: <1382950480-12515-1-git-send-email-mpa@pengutronix.de>
In-Reply-To: <1382950480-12515-1-git-send-email-mpa@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4dnXTfDLU5AKrpl31p0R3g43N5dRwOnSQ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4dnXTfDLU5AKrpl31p0R3g43N5dRwOnSQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/28/2013 09:54 AM, Markus Pargmann wrote:
> If we handle end of block messages with higher priority than a lost
> message, we can run into an endless interrupt loop.
>=20
> This is reproducable with a am335x processor and "cansequence -r" at
> 1Mbit. As soon as we loose a packet we can't escape from a interrupt
> loop.
>=20
> This patch handles lost packets before EOB packets.
>=20
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>

Thanks, applied to can.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--4dnXTfDLU5AKrpl31p0R3g43N5dRwOnSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJuKXQACgkQjTAFq1RaXHM61wCeLbbGwIVvk5Z2oympmZZJQhAo
E24AmwbRsez7TxFD2bT/EVEBNDTRJYkH
=agCZ
-----END PGP SIGNATURE-----

--4dnXTfDLU5AKrpl31p0R3g43N5dRwOnSQ--
