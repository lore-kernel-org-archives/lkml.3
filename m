Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3I3HzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:55:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3I3HzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:55:08 -0400
Message-ID: <52492E4F.2020701@pengutronix.de>
Date: Mon, 30 Sep 2013 09:54:55 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 01/21] drivers: remove unnecessary prom.h includes
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com> <1380221456-11192-2-git-send-email-robherring2@gmail.com>
In-Reply-To: <1380221456-11192-2-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xktXMclENS0wfIOadoWo9wEvOknUc3Ljc"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xktXMclENS0wfIOadoWo9wEvOknUc3Ljc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/26/2013 08:50 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> Remove unnecessary prom.h includes in preparation to remove implicit
> includes of prom.h.
>=20
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org

Applied to linux-can-next/testing, it will be included in my next pull
request to David Miller.

tnx,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--xktXMclENS0wfIOadoWo9wEvOknUc3Ljc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJJLk8ACgkQjTAFq1RaXHMeJACeK9HZUEC1VQZeq2GzjerfTgrG
ckcAniqhgxJhqm/Ho/b7PXMpVeEW1pRc
=ixWT
-----END PGP SIGNATURE-----

--xktXMclENS0wfIOadoWo9wEvOknUc3Ljc--
