Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaGNOJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:09:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53021 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbaGNOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:09:13 -0400
Message-ID: <53C3E480.9050509@pengutronix.de>
Date: Mon, 14 Jul 2014 16:09:04 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405322992.git.stefan@agner.ch> <3b047f9eb64ef01a958d83706af8f7e973358420.1405322992.git.stefan@agner.ch> <53C38FD9.8070403@pengutronix.de> <5b42e19c9741a0b54420ade131f84408@agner.ch>
In-Reply-To: <5b42e19c9741a0b54420ade131f84408@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RsDh3gfSSlDMq3q3tChvg3qj3osDcVfBT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RsDh3gfSSlDMq3q3tChvg3qj3osDcVfBT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/14/2014 03:37 PM, Stefan Agner wrote:
> Am 2014-07-14 10:07, schrieb Marc Kleine-Budde:
> <snip>
>>> +	/*
>>> +	 * On Vybrid, disable memory error detection interrupts
>>> +	 * and freeze mode.
>>> +	 * This also works around errata e5295 which generates
>>> +	 * false positive memory errors and put the device in
>>> +	 * freeze mode.
>>> +	 */
>>> +	if (priv->devtype_data->features & FLEXCAN_HAS_MECR_FEATURES) {
>>> +		/*
>>> +		 * Follow the protocol as described in "Detection
>>> +		 * and Correction of Memory Errors" to write to
>>> +		 * MECR register
>>> +		 */
>>
>>
>> One nitpick regarding the comment. In driver/net, the preferred
>> multi-line comment style is
>>
>=20
> Just a few lines above that one, another multi-line comment is written
> with the empty line at start... With this changed to the net comment
> style, we would end up in a mixed style... What do you think?

Okay, keep the commenting style of the driver.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--RsDh3gfSSlDMq3q3tChvg3qj3osDcVfBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPD5IAACgkQjTAFq1RaXHMY5gCfeUbTin+poDkUmRCsvu/o4IfJ
/egAoI0S5pF3bJ5s04/YPaol2N6kWmkZ
=MyXP
-----END PGP SIGNATURE-----

--RsDh3gfSSlDMq3q3tChvg3qj3osDcVfBT--
