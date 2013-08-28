Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3H1JKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:10:24 -0400
Received: from sauhun.de ([89.238.76.85]:50142 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3H1JKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:10:22 -0400
Date: Wed, 28 Aug 2013 11:10:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 1/2] i2c-designware: make HCNT/LCNT values configurable
Message-ID: <20130828091019.GD4086@katana>
References: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
In-Reply-To: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 03:07:53PM +0300, Mika Westerberg wrote:
> The DesignWare I2C controller has high count (HCNT) and low count (LCNT)
> registers for each of the I2C speed modes (standard and fast). These
> registers are programmed based on the input clock speed in the driver.
>=20
> The current code calculates these values based on the input clock speed a=
nd
> tries hard to meet the I2C bus timing requirements. This could result
> non-optimal values with regarding to the bus speed. For example on Intel
> BayTrail we get bus speed of 315.41kHz which is ~20% slower than we would
> expect (400kHz) in fast mode (even though the timing requirements are met=
).
>=20
> This patch makes it possible for the platform code to pass more optimal
> HCNT/LCNT values to the core driver if they are known beforehand. If these
> are not set we use the calculated and more conservative values.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied to for-next, thanks!


--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHb56AAoJEBQN5MwUoCm2MzcP/3FhsmQ4yp+TJVbFnytWyl6O
SKboOLuMIA2Q/Kdza69hdhMnTJleLRKAnogVqVM5iShZ/ega4RNr+nS5WS4Msl1R
qYrvh70QOOpeb0Tt9zHqfqKvZrsY7u2H2m5IOichLJlnRpX2Lmbwo5dY7T4FszVD
wWOWhJA+u13z3P/8uL3jAdxWSLMwgji+UC4cWR2MjHWePWscT3SYyawzJOuZWD5X
rnkKt61JZYKy+035sjvKbDY1q60P6GS8/1nHAftsaEf8lxoqIgNTKR2TYUwSlD3U
flY6FReu9rJa+Nnk9DcXPNqT4gcJ0WO3obl3puG7i5lkhbANN5utEgTAXRZvh8XE
ZP6rcHqEViponCqv8S0Y0slEeGHF72H0alVkrzFehYcoBCG2YdBfCNqO7DlkTUrP
46MwtSqhw405FUn7Lk9GMHM/zZks2nXh4nluoNfRTBTnlfkKjo/yKhsrRDbMP9xh
NCSNvaoNs/elWYBa+bXWpTuhnTqTc0760wpVCsxhYB3deeovaZ+WWwlSD4CcNITH
ldolekOPKYbeTgivgtwRDvxcfG8GMqktOVeQBi7ulOoXv4rH9ySK2N4oG4UoatoO
TJXkTF2GbpMzyYNS2P4mGPCARigM2V8juHF15uc9/RuzXBfc3JDIjetmutDzq5zI
jPO2HQDNKRaD47usHi6x
=vgcO
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
