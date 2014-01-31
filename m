Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaAaMhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:37:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56308 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbaAaMhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:37:31 -0500
Message-ID: <52EB9908.2090903@pengutronix.de>
Date: Fri, 31 Jan 2014 13:37:28 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] can: sja1000: cleanups and new OF property
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Oa7Sro6m073fX57KnHK4WQbfb7s48rxXQ"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Oa7Sro6m073fX57KnHK4WQbfb7s48rxXQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 11:35 AM, Florian Vaussard wrote:
> Hello,
>=20
> Changes sinces v1:
> - Merge sja1000_of_platform.c into sja1000_platform.c (patch 4)
>=20
> The first part of this series performs serveral small cleanups
> (patches 1 to 3).
>=20
> Patch 4 merges sja1000_of_platform.c into sja1000_platform.c.
> Changes are pretty conservatives (mostly copy/paste/move). IRQ
> is treated differently in the OF and non-OF versions, thus this
> is where the fused version differs the most.
>=20
> The final part introduces the 'reg-io-width' binding (already used
> by some other drivers) to perform a similar job as what was done
> with IORESOURCE_MEM_XXBIT. This is needed on my system to correctly
> take into account the aliasing of the address bus.

Good work, please keep compatibility for DTs without the 'reg-io-width'
binding. The rest of my comments are only nitpicks. :)

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--Oa7Sro6m073fX57KnHK4WQbfb7s48rxXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLrmQgACgkQjTAFq1RaXHO95QCcC/M7NBTZHBMhoIfldr5iPzJA
z/sAn3TxzCSDJMBKRfLPp/skNhrGeEFa
=Fotn
-----END PGP SIGNATURE-----

--Oa7Sro6m073fX57KnHK4WQbfb7s48rxXQ--
