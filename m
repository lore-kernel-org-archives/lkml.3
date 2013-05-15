Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3EOJM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:12:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56676 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3EOJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:12:25 -0400
Message-ID: <51935176.7020601@pengutronix.de>
Date: Wed, 15 May 2013 11:12:22 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laurent Navet <laurent.navet@gmail.com>
CC: wg@grandegger.com, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: can: grcan: use devm_ioremap_resource()
References: <1368458871-7402-1-git-send-email-laurent.navet@gmail.com>
In-Reply-To: <1368458871-7402-1-git-send-email-laurent.navet@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XBWSEMHMNHGLBVGGESLH"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XBWSEMHMNHGLBVGGESLH
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 05/13/2013 05:27 PM, Laurent Navet wrote:
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_r=
esource.
> dev_err() message is no more needed since it's already displayed in
> devm_ioremap_resource().
>=20
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Tnx, applied to linux-can-next.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2XBWSEMHMNHGLBVGGESLH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGTUXYACgkQjTAFq1RaXHODhQCgkcZrUt927CdlmRzeERfThveE
29AAn0gKm8BPeY7xxguZiPV4W+PnFNP4
=oosW
-----END PGP SIGNATURE-----

------enig2XBWSEMHMNHGLBVGGESLH--
