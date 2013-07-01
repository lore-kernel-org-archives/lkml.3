Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3GAGkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:40:32 -0400
Received: from sauhun.de ([89.238.76.85]:50939 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3GAGka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:40:30 -0400
Date: Mon, 1 Jul 2013 08:40:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 2/4] i2c: Kontron PLD i2c bus driver
Message-ID: <20130701064021.GC2976@katana>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-3-git-send-email-kevin.strasser@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <1372046406-3127-3-git-send-email-kevin.strasser@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 23, 2013 at 09:00:04PM -0700, Kevin Strasser wrote:
> Add i2c support for the on-board PLD found on some Kontron embedded
> modules.
>=20
> Originally-From: Michael Brunner <michael.brunner@kontron.com>
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Applied to for-next, thanks!


--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0SRVAAoJEBQN5MwUoCm2/+UP/RPh/wU3W8bFioYWoOrGJK1B
0t2PHKVAqhcEwZnSFNxCo5hh/XIM/oDXdjKMsdPBZEMAQ+QL1f3bVjS3cb5xflbm
F3bLCaM48kIve+A5bprj913ikdTbWkuuagcQrry64i3aDcG4Tsb4WaCX4BjE0Fb1
LNiwrqHrmpxWHwBsFYiucWiyBqXFwKrq0P0Gb0Gi+/RctWR4Aoi35V+5qbmDAf+s
/sFMbTM7dfknKaeuiuUjmsQ2ZxkWhAmMbmQN6f5ry1SJgjf00h/UDb0yJBKC9BsI
X5cvANdDZdMVhN/lLAj1nIPAjHYNgb0Q8b+lEnkhhndQPMziOlZPeUfkNKlyCTE6
B0OcKW2yih0O/PwTNRV4AH7d+Rt/RpTLH3kk8mv+XlGk+9AbMks0C1pciumX9RWQ
1wV57ADZupDildbWA8Sm6r2MG8Y+kszkt0+2bbTFmpnOodFX/2/7Lj5kSIYWhVlJ
wbROLkszzBk2eLBuUSKdZadgAyz0Xyf0PMeLX/u6/s85qQ5oDyN9jfGle4Nlkugd
2JF7EzOcrv2/l+XIQ/Ax29XtiRZouu2tVZ/9WuJii1wbxb8xp4LAktY1pQawCaay
m0n3M4GkjGOfJToNtQ0WVB4e/ZWZQZmvw+pqWVeEFQZt6IbYFc6NiiyXZHX479XA
HpRVxnPhccnXowK2OT/b
=KOFD
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
