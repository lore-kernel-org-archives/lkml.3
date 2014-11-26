Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaKZRzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:55:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39616 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaKZRzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:55:12 -0500
Date: Wed, 26 Nov 2014 17:53:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20141126175304.GM7712@sirena.org.uk>
References: <546B5EF9.3080102@mentor.com>
 <546CAB49.8030103@mentor.com>
 <20141125121749.GV7712@sirena.org.uk>
 <54760D6A.9080306@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hzVtCVhCZp1LI1Y"
Content-Disposition: inline
In-Reply-To: <54760D6A.9080306@mentor.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Question about fixed regulator DT properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+hzVtCVhCZp1LI1Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 26, 2014 at 07:27:06PM +0200, Vladimir Zapolskiy wrote:
> On 25.11.2014 14:17, Mark Brown wrote:

> b) "regulator-boot-on" does not mean that the regulator is controlled by
> bootloader or firmware exclusively.

That's correct...

> >>> Should documentation be updated to reflect "regulator-boot-on" role that
> >>> a regulator is re-enabled by the kernel?

> > I'm confused about this.  That's the sole purpose of the flag and as far
> > as I can tell it's what the documentation says.

> Documentation/devicetree/bindings/regulator/regulator.txt says:

>   - regulator-boot-on: bootloader/firmware enabled regulator

> I would suggest to add Linux kernel to that list of regulator
> controllers, if it is the intention. In its current state the
> documentation makes an impression that "regulator-boot-on" property
> instructs the kernel to ignore regulator setup, since it is already
> controlled by bootloader or firmware.

No, not at all.  It's referring to the state when Linux starts.

--+hzVtCVhCZp1LI1Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdhOAAAoJECTWi3JdVIfQq6UH/jt3gaVEV5KPfzrDUZHiTkoI
H931grOZ4XPifKIIv3FjAB2Bb0gTj9g5R3Y/1DeZ6yPyjdOQ3hSGXo8C6ARoYn6k
LgUcpz6sUufE7OOLk5AfnX4KK6BA/L/nkPYKkw2ISjLqmFF2c8G5d3oUZp+V0FWH
ZlZN/ST1kOXOjLPzt95AgDg2bIcS0vBp1omzRHx4vIHQHP5sPX9f6nHHLfFD60hG
VqK/GQq1w4NEXFiat0GtMgHDu+r2LmGcRFK0h+FkI1KI5y/9g1UzKvE7rh6cI8/j
O+uIvOA4wuB0Y9XJgDj2RaVrM/s/DUlzAqQ7bHqPVdyyPxegR4rlbYnM4StziaA=
=hEx/
-----END PGP SIGNATURE-----

--+hzVtCVhCZp1LI1Y--
