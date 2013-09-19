Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3ISJsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:48:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52522 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3ISJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:48:07 -0400
Message-ID: <523AC84D.5030305@pengutronix.de>
Date: Thu, 19 Sep 2013 11:47:57 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: davem@davemloft.net, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/3] slcan: rewrite of slc_bump and slc_encaps
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com> <1379093833-4949-4-git-send-email-nautsch2@gmail.com>
In-Reply-To: <1379093833-4949-4-git-send-email-nautsch2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="98l0NRXL1hAQOiWrNi9Rat0AfWGPhfRhK"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--98l0NRXL1hAQOiWrNi9Rat0AfWGPhfRhK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/13/2013 07:37 PM, Andre Naujoks wrote:
> The old implementation was heavy on str* functions and sprintf calls.
> This version is more manual, but faster.
>=20
> Profiling just the printing of a 3 char CAN-id resulted in 60 instructi=
ons
> for the manual method and over 2000 for the sprintf method. Bear in
> mind the profiling was done against libc and not the kernel sprintf.
>=20
> Together with this rewrite an issue with sending and receiving of RTR f=
rames
> has been fixed by Oliver for the cases that the DLC is not zero.
>=20
> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--98l0NRXL1hAQOiWrNi9Rat0AfWGPhfRhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlI6yE0ACgkQjTAFq1RaXHPXqQCdGprMtXxqWRMPy4iZagdkND27
9xcAnRLi+U9khmsQJYwko/kzvkUUpLGg
=m1DH
-----END PGP SIGNATURE-----

--98l0NRXL1hAQOiWrNi9Rat0AfWGPhfRhK--
