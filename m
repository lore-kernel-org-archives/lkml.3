Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaJHOhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:37:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40803 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaJHOhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:37:01 -0400
Date: Wed, 8 Oct 2014 15:36:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141008143632.GC4609@sirena.org.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-5-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpveMUvXs97SUkgl"
Content-Disposition: inline
In-Reply-To: <1412775847-15213-5-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] regulator: max77802: Add regulator operating mode
 set support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpveMUvXs97SUkgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 03:44:06PM +0200, Javier Martinez Canillas wrote:
> Add a function handler for the struct regulator_ops .set_mode so an
> operating mode (opmode) can be set for regulators.
>=20
> Regulators opmode are defined using the generic REGULATOR_MODE_*
> modes so the driver maps these generic modes to the device-specific
> operating modes as stated in the hardware data-sheet.

Why is this implementing a set operation but not a get operation?

--LpveMUvXs97SUkgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNUvwAAoJECTWi3JdVIfQ+egH/AzTAD46kL1iB/BKJ5q6R0sI
tdDXExvBp7lOBG48vWxTk2IXVZuls0aK0a9nHX7x9drIZKsQgiVO8QDKFzJ0Ej9J
ZzAg9qZGHGvaciS+1nFhpQj32GgIb1BAnp54yR7SrUpoAmxhf3xHuBW6HjsHNZHI
SxPlM+3R8STQHZbNQ+v5cRmNQooOq/Cu10q38kTBX6j6KC2+Kq9/6p2tF/FqfiV6
/SohXYv5M37FjYticvoYw9JfwG7244fZ3q7jNGhtajvp9+A5E7E1eHCi/CPdbyAq
VpF0ztWyas3cxfD4oJPSSLFqtO4+la6M/zB4kUpoID92/4Ozq4/Fz8ZabbvGtGA=
=5XOQ
-----END PGP SIGNATURE-----

--LpveMUvXs97SUkgl--
