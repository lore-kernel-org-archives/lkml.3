Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaGJIvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:51:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59050 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaGJIvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:51:16 -0400
Message-ID: <53BE53F8.9090405@pengutronix.de>
Date: Thu, 10 Jul 2014 10:51:04 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org
Subject: Re: [PATCH v7 31/33] net: slcan - set name assign type
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <1404980258-30853-32-git-send-email-teg@jklm.no>
In-Reply-To: <1404980258-30853-32-git-send-email-teg@jklm.no>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3NThhxWj3tlRBlbxiOJleNhGoA8t3Q9eX"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3NThhxWj3tlRBlbxiOJleNhGoA8t3Q9eX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/10/2014 10:17 AM, Tom Gundersen wrote:
> Names are given by the first available SLCAN channel, so order
> of device creation matters.
>=20
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: linux-can@vger.kernel.org

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--3NThhxWj3tlRBlbxiOJleNhGoA8t3Q9eX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlO+U/gACgkQjTAFq1RaXHMpmQCggsNcSP8juogA2SKk/SeMIS24
pswAn1E8kgIno+JcjRvowGfmQlKUXtM5
=eUHW
-----END PGP SIGNATURE-----

--3NThhxWj3tlRBlbxiOJleNhGoA8t3Q9eX--
