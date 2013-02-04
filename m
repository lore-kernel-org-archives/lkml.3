Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3BDJCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:02:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58996 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3BDJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:02:13 -0500
Message-ID: <510F790B.3060508@pengutronix.de>
Date: Mon, 04 Feb 2013 10:02:03 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] can: Remove unnecessary alloc/OOM messages
References: <cover.1359939012.git.joe@perches.com> <4bcd953ce87ecab86e000443df36a2867927c96e.1359939013.git.joe@perches.com>
In-Reply-To: <4bcd953ce87ecab86e000443df36a2867927c96e.1359939013.git.joe@perches.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LILJNEMMDBAHXUFIGAAD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LILJNEMMDBAHXUFIGAAD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/04/2013 04:28 AM, Joe Perches wrote:
> alloc failures already get standardized OOM
> messages and a dump_stack.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2LILJNEMMDBAHXUFIGAAD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEPeQ8ACgkQjTAFq1RaXHPAwwCfalMFWS4CHlrDEYQ2RNGCNlYF
Wj4AniRXiE+bFKYqvN/Op/niXW7yHHnc
=wTU7
-----END PGP SIGNATURE-----

------enig2LILJNEMMDBAHXUFIGAAD--
