Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab3BGX37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:29:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759525Ab3BGX35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:29:57 -0500
Message-ID: <511438CA.8060003@pengutronix.de>
Date: Fri, 08 Feb 2013 00:29:14 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, wil6210@qca.qualcomm.com,
        brcm80211-dev-list@broadcom.com,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] drivers: net: Remove remaining alloc/OOM messages
References: <1360273587.27863.15.camel@joe-AO722>
In-Reply-To: <1360273587.27863.15.camel@joe-AO722>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2UHVEOGTHORNDWVVOWLUJ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UHVEOGTHORNDWVVOWLUJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/07/2013 10:46 PM, Joe Perches wrote:
> alloc failures already get standardized OOM
> messages and a dump_stack.
>=20
> For the affected mallocs around these OOM messages:
>=20
> Converted kmallocs with multiplies to kmalloc_array.
> Converted a kmalloc/memcpy to kmemdup.
> Removed now unused stack variables.
> Removed unnecessary parentheses.
> Neatened alignment.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Let me know if you want multiple small patches instead.
>=20
>  drivers/net/can/usb/ems_usb.c                      |  4 +-

For ems_usb.c

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2UHVEOGTHORNDWVVOWLUJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEUON8ACgkQjTAFq1RaXHNawgCghkTouziZz1s9EyqAQmRtnyTg
t5QAoIsLAx7+P28BtRi4ralrnaIxHHZm
=jak+
-----END PGP SIGNATURE-----

------enig2UHVEOGTHORNDWVVOWLUJ--
