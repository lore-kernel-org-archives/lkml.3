Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaESQSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:18:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33329 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaESQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:18:51 -0400
Date: Mon, 19 May 2014 17:18:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140519161838.GB12304@sirena.org.uk>
References: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
 <20140519143949.GW12304@sirena.org.uk>
 <20140519172556.17c49589@avionic-0020>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCZifdKbOkLmCpsL"
Content-Disposition: inline
In-Reply-To: <20140519172556.17c49589@avionic-0020>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix the init of DT defined fixed
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCZifdKbOkLmCpsL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 05:25:56PM +0200, Alban Bedel wrote:

> Would checking that the regulator is at the voltage declared in the DT
> better? Or should I just add a pseudo set method to the regulator driver
> that only accept the current voltage? That could also be implemented at
> the core level using a default method for all regulators that have a get
> but no set method.

We already have code in the core to accept set_voltage() on fixed
voltage regulators - are you sure you're working with current code?
Otherwise fixing things to go through the standard set_voltage() path
would be OK.  There should be no need to add a dummy function for
setting.

--rCZifdKbOkLmCpsL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTei7bAAoJELSic+t+oim9lRAQAJItrEDfvP/AQSk0DtJUuZ8H
nAEsBYuN5mY1EYfq96aRmlcHKWcoLINVVb1eWtFeqFVLnJFSJEYLceDMP+NgfUrN
v5dCTUTQFHvXjUCXx/yYzbAb8cBq+xDw+ZG5zgAaXLgRnFP6SJ2gmirueVapWrZt
sYhNT28wk6bc4u3m7PNwozxCFEVwbQn8VyxrK/biylycEwqTjjjEaTZts056RAGx
JQW3aI3ltxzl5aZefsfCf8zRs+mA5NvxYGFs4RtYOILgNOlMpTZQdo6u6QIk4ZBc
v2GGFp+MzpjPbO/B2INKqXS/2g90ISxYNfggss8mCW0ZbIyPofNWAfu1IjzaQv5/
NBiAEJ5yNego+LDNbAzd+ewnuH3UTDJuR3WwjKTtQ/0MbYwP4+tYTWcAhU22yvik
4qlvKVLk00q3Edr8ntD5qSoi0X8W2IIV2qGnsnXDLOV1FuCZ05ZuL3p6+FDYs+V3
vf6xZdgbjITF7EN9+/GE4PDsoBEqENWwtop2Qtbmxb5X6VAwTnZF0bHdQCjHov+v
X42xAvaEjB+/Qi8ZOlWKF3s3QJEUnBM0/AtRbadwjd7owWVfoFLq8mqdk1uU2IqO
tYICJX5U5PuOf9iL3yiC0AMu82+4fCPCmT//zMIqyZI0kdsx+iwTF7JGGYYGH2wZ
cmYKP0k0UCgB70ANCiYz
=OSJa
-----END PGP SIGNATURE-----

--rCZifdKbOkLmCpsL--
