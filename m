Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaIXWde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:33:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39114 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIXWdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:33:33 -0400
Date: Wed, 24 Sep 2014 23:33:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: atull <atull@opensource.altera.com>, jdelvare@suse.de,
        lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Message-ID: <20140924223322.GL16977@sirena.org.uk>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
 <1411581476-12222-4-git-send-email-atull@opensource.altera.com>
 <20140924201934.GB25362@roeck-us.net>
 <alpine.DEB.2.02.1409241536530.9901@atx-linux-37>
 <20140924211332.GA2720@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TnYVF1hk1c8rpHiF"
Content-Disposition: inline
In-Reply-To: <20140924211332.GA2720@roeck-us.net>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/3] pmbus: ltc2978: add regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TnYVF1hk1c8rpHiF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 02:13:32PM -0700, Guenter Roeck wrote:
> On Wed, Sep 24, 2014 at 03:48:40PM -0500, atull wrote:

> > > regulator.47/name:vout_en0

> > These are just default names, but I think I could make the name better.
> > How about <part #>-<i2c address>-vout<#> such as "ltc2978-5c-vout0"

> Problem with that is that i2c bus numbers are not static, which would
> make it quite difficult to describe the regulator in devicetree data.

> Any idea what other regulators do in such situations ?

What's there is correct (modulo the _en), the names are local to the
chip.  If the user actually cares they will be providing the name of the
supply on the board anyway.

--TnYVF1hk1c8rpHiF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUI0axAAoJECTWi3JdVIfQInMH/RbfyjTMj6zANj0/OYJQlGtG
PJSt/NhGoTG8yOcsYCan5B27cSU6/l6yJjVHPpOfABFZXI4NCXeEg6WLukmGRG+p
GKmf/p28TKan5wmj3WEG+/FGDB1VEXHNxAgqq+kkbU0BRoa4R683uqJybCTx6X+0
g9/zy4wdmLfb82pJaJIAwhiiYwxUoQ75B1IlHY02l2W0xDP2MiF/PAzjYUSQORr3
CeVjc406HkIlAjpMV4a3hoSNp0V99f1H2/ub53+gQKk2dVJlmKL/0Hmyhn2EtYkl
aoHckrTTbslqYpquLMjh/yrY5xmXLkSHK1nc6oY6FZVRn2Y51mBqT+me+TUvS8E=
=qg4M
-----END PGP SIGNATURE-----

--TnYVF1hk1c8rpHiF--
