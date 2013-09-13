Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3IMKAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:00:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48556 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3IMJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:59:57 -0400
Date: Fri, 13 Sep 2013 10:59:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130913095950.GA29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ag9GjZJb+BqU9eEI"
Content-Disposition: inline
In-Reply-To: <20130913065434.GZ7393@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ag9GjZJb+BqU9eEI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 13, 2013 at 09:54:34AM +0300, Mika Westerberg wrote:
> On Thu, Sep 12, 2013 at 02:34:21PM -0700, Kevin Hilman wrote:

> > For hardware that is disabled/powered-off on startup, there will now be
> > a mismatch between the hardware state an the RPM core state.

> The call to pm_runtime_get_noresume() should make sure that the device is
> in active state (at least in state where it can access the bus) if I'm
> understanding this right.

Accessing the bus isn't an issue for I2C outside of ACPI, the power
management of the device is totally disassociated from the bus and the
controller is responsible for ensuring it is available during transfers.

--ag9GjZJb+BqU9eEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMuITAAoJELSic+t+oim9+UsP/RcwTsiMmpTycarTP0qbabI9
pDh2oUMQl0geVLAVlcp34HYImPA6BVChH8zPkRgOr/F5mDHl7q2wjj7K5oEFP/vI
UL14mJEZnAU9GMzWgorU8zI3z/nFHB5KpjSBOrPVHar1dK2+ZhnEwJpF0bNx+OUP
yHXAMkUUtRWxuDwMWtS+yKd/5fxKvLXsNrVFce9biXPj4L9dML5jsAi59jX8SKkQ
9ESBxxqMRH91v6CZ99JGR8pAat8eOTrQUlHaEKWtmQwm/eraBVjJwA5TJ9IdPmIC
EXEwhbMRA7Gr5hNAPBXVQQsqa4zQYeGxkbbn+57cZIB2SaxSQidIARp4ld4ZWREa
IZq8D6odOt8oGqSLYp7eKL2kmn2xV4wsff1GsWudNJlfpS33q8szVZNDqY+K08Qf
FGpxpv4Rd3yXdUIvjvvKZ/TjLWHLJn9/xYjQP8OB98m8SK7qzAYIUJoYY/RJz20M
4lZux3tihn6FEI3uSoqWJHi3vEnF59jPWa2jAnVewV+E5GPcfNruYhJtWyxvaHOo
oTpi84yocGk9134/ipRLEDm6SOMdPdPiZ4anR6vU3UgHN8SircH+2IoJRWe1+zts
TzfzyWv7YeoH/k13g+ny3aw7tBvk35yxStNIghubFNdkfFTqURV2msxIx8k6waIE
nEqM+ElcVhk6LPp8aHPE
=ARg5
-----END PGP SIGNATURE-----

--ag9GjZJb+BqU9eEI--
