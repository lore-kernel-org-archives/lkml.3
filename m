Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaHOIh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:37:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaHOIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:37:25 -0400
Message-ID: <53EDC6BD.6060200@pengutronix.de>
Date: Fri, 15 Aug 2014 10:37:17 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: dev: remove unused variable from can_calc_bittiming()
 function
References: <1407399444-16427-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1407399444-16427-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="u6QTOxh7TXJHV5hNdxQ4D5e3T1fw3ToAP"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u6QTOxh7TXJHV5hNdxQ4D5e3T1fw3ToAP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/07/2014 10:17 AM, Lad, Prabhakar wrote:
> this patch removes best_rate variable from can_calc_bittiming()
> function which was set but was never used.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Applied to can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--u6QTOxh7TXJHV5hNdxQ4D5e3T1fw3ToAP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlPtxr0ACgkQjTAFq1RaXHMZYQCggxNa5yiPtv05eVkZ8KNvnz7s
Z3IAnAhSG4zxlIPIu/db2fcQ0toeJq7i
=6nTI
-----END PGP SIGNATURE-----

--u6QTOxh7TXJHV5hNdxQ4D5e3T1fw3ToAP--
