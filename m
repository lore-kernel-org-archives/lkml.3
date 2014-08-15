Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaHOIiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:38:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51103 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaHOIiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:38:17 -0400
Message-ID: <53EDC6E7.4070101@pengutronix.de>
Date: Fri, 15 Aug 2014 10:37:59 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Stefano Babic <sbabic@denx.de>, Jingoo Han <jg1.han@samsung.com>,
        Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH] can: mcp251x: Use dmam_alloc_coherent
References: <20140802135204.GA7635@himangi-Dell>
In-Reply-To: <20140802135204.GA7635@himangi-Dell>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WajkRJqFCfTIvB4Ks3QUJtAq3pTEWkTsA"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WajkRJqFCfTIvB4Ks3QUJtAq3pTEWkTsA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/02/2014 03:52 PM, Himangi Saraogi wrote:
> This patch moves the data allocated using dma_alloc_coherent to the
> corresponding managed interface and does away with the calls to free th=
e
> allocated memory in the probe and remove functions.
>=20
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied to can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--WajkRJqFCfTIvB4Ks3QUJtAq3pTEWkTsA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlPtxucACgkQjTAFq1RaXHMTZwCfc/jtAIAOHaOal3OQwrDLztYO
mR0An0C7f4HAE3Zm/2L+ZmXOSoCVz7QG
=f6YB
-----END PGP SIGNATURE-----

--WajkRJqFCfTIvB4Ks3QUJtAq3pTEWkTsA--
