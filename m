Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3ETTxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:53:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48105 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab3ETTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:53:38 -0400
Message-ID: <519A7F3B.1000105@pengutronix.de>
Date: Mon, 20 May 2013 21:53:31 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/can/mcp251x: Use module_spi_driver to register driver
References: <1369079399-6031-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369079399-6031-1-git-send-email-peterhuewe@gmx.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BHRVFPFOJSVBFLSSESXQ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BHRVFPFOJSVBFLSSESXQ
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 05/20/2013 09:49 PM, Peter Huewe wrote:
> Removing some boilerplate by using module_spi_driver instead of calling=

> register and unregister in the otherwise empty init/exit functions
>=20
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

A similar patch [1] by Lars-Peter Clausen hit mainline in v3.10-rc1.

thanks, Marc

[1] 01b8807 can: mcp251x: Use module_spi_driver

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2BHRVFPFOJSVBFLSSESXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGafz8ACgkQjTAFq1RaXHOnPwCeKYOEOM+NtswjyjF5CbgMibLV
2u4An1Bhk6PVqz1Ll+Q7S0tXhATsksSd
=8K45
-----END PGP SIGNATURE-----

------enig2BHRVFPFOJSVBFLSSESXQ--
