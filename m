Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaEOQHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:07:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35688 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaEOQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:07:47 -0400
Date: Thu, 15 May 2014 11:07:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <joe@perches.com>, <auttamchandani@logicube.com>
Subject: Re: [PATCH 2/2 v4] usb: gadget: net2280: Add support for PLX USB338X
Message-ID: <20140515160735.GF7360@saruman.home>
Reply-To: <balbi@ti.com>
References: <1400156926-11100-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400156926-11100-2-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
In-Reply-To: <1400156926-11100-2-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 02:28:46PM +0200, Ricardo Ribalda Delgado wrote:
> This patch adds support for the PLX USB3380 and USB3382.
>=20
> This driver is based on the driver from the manufacturer.
>=20
> Since USB338X is register compatible with NET2280, I thought that it
> would be better to include this hardware into net2280 driver.
>=20
> Manufacturer's driver only supported the USB33X, did not follow the
> Kernel Style and contain some trivial errors. This patch has tried to
> address this issues.
>=20
> This patch has only been tested on USB338x hardware, but the merge has
> been done trying to not affect the behaviour of NET2280.
>=20
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

anybody with net2280, please give me a Tested-by so I'm sure there are
no regressions caused by this patch. One question though, is it worth to
use the legacy mode just to get register compatibility ? What are the
drawbacks of using legacy mode ? Is any feature missing when we use
legacy mode ?

cheers

--=20
balbi

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdOZHAAoJEIaOsuA1yqREqP0P/iN3/EWHS8XpxUKNAk7WqG9a
X3shjZJqNm2FI4BTfRzkKDWXOClV6NBX9Dje7hkOpdrLF3mhjcuT+3bFWJc+QJ3m
/AnqfWTzru7XpsAFtgCu2V3YbsM9ouetR+A/NC3MRhgNk8RbbgSyM+3nrj+UpLe8
hWhCPbFZ7VNp11PiruhV8LtW4t78DjmBD4+2zYiMGhUo/i9mvZIhH3S13UlEP85k
9xIMvPimjZ7UjLtioJxCDAX/U5J3rO1TXhFqmRZk+94Q1bESs9eN09WBRjxKBk0v
3D4DexJs7k6JZUyttjbWtJ4Os8SfOzY8qeF7PRKpRUTDalRoIM9RozHLwvXnmeXg
wls0xPL237AN3wRFsSwIhSOySM4BZZolBHfR4YPbzANK6q2AuLL+mqCiJLlwb6S9
XwmoM3ti7CYQSjCAmenBHVQm3edZGw4ROvHkLFYAc0h+jtX0Pmbyj+5+K/sFp+R6
oEK/e3qHhgQp/sxEm1OP/Ij9G5sG+CTM3+8/VuVzw9FDUtkaeLaMseEXGSWU7S3i
HHr7eZLWMOHZ1lisj3H6A6owaCttUlvbcXM0ZOVWcJ7gVHFXgMJDC4t9c6kfssSe
nAnKv3R3UsCl43N9KcnUZYkSILzG+fcCO+HUCggg1WNSbVa/q3J0uMDufj6RLaHS
/wsSWv7X88ukdz3Vhwa7
=/hpW
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
