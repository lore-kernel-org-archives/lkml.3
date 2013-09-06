Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab3IFJDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:03:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36241 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3IFJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:03:41 -0400
Message-ID: <52299A64.2070102@pengutronix.de>
Date: Fri, 06 Sep 2013 11:03:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        "s.grosjean@peak-system.com" <s.grosjean@peak-system.com>
Subject: Re: [PATCH] can: pcan_usb_core: fix memory leak on failure paths
 in peak_usb_start()
References: <1378331169-26285-1-git-send-email-khoroshilov@ispras.ru> <52285006.3080303@pengutronix.de>
In-Reply-To: <52285006.3080303@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6FpgdfratEXkxcwuFFvJ9XNSWqAnvfIo2"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6FpgdfratEXkxcwuFFvJ9XNSWqAnvfIo2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/05/2013 11:33 AM, Marc Kleine-Budde wrote:
> Added Stephane to Cc.
>=20
> On 09/04/2013 11:46 PM, Alexey Khoroshilov wrote:
>> Tx and rx urbs are not deallocated if something goes wrong in peak_usb=
_start().
>> The patch fixes error handling to deallocate all the resources.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>=20
> Stephane, can you have a look at the patch and give your Acked-by.
>=20
> Looks good to me.

Applied with Stephane's Acked-by to can/fixes-for-3.12.

Tnx,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--6FpgdfratEXkxcwuFFvJ9XNSWqAnvfIo2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlIpmmQACgkQjTAFq1RaXHO3tgCeIBu44NqG47DMuQNm6Ln4bQJq
Pn4AnRxd0iV9KNTmAuRBRgVl24qt4h0y
=pDo0
-----END PGP SIGNATURE-----

--6FpgdfratEXkxcwuFFvJ9XNSWqAnvfIo2--
