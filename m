Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3IKPv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:51:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39590 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3IKPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:51:24 -0400
Date: Wed, 11 Sep 2013 16:51:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
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
Message-ID: <20130911155120.GW29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-9-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I+QmG5g5EzYJzIBt"
Content-Disposition: inline
In-Reply-To: <1378913560-2752-9-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 8/9] spi: prepare runtime PM support for SPI devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I+QmG5g5EzYJzIBt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2013 at 06:32:39PM +0300, Mika Westerberg wrote:
> This patch adds runtime PM support for the SPI bus analogous to what has
> been done for the I2C bus. This means that the SPI core prepares runtime PM
> for a client device just before a driver is about to be bound to it.
> Devices that are not bound to any driver are not prepared for runtime PM.

Acked-by: Mark Brown <broonie@linaro.org>

I would be able to have this and the other patch in the SPI tree in case
it overlaps with other work - I'm not sure what the plan will be for
merging this stuff but if there were a branch which I could merge into
the SPI tree that'd be good.

--I+QmG5g5EzYJzIBt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMJF1AAoJELSic+t+oim9xkMP/3dswSEliXhfalyn0oJ8Sofd
PE9LqIgWMrB/J054BQAV+lF/UBftlZU9NMM8gxchtrz8qum12jtzj8ny4absmm1N
w3SwUfpg+Mq+k7guO+gDeKI8OrAkXkWZyT0tBq7uXgrvPibI6OIt4pwaBPK9uIh/
z23lH/IJc9MAy7VZg1HfjKs93xFZzeMYa7+ZPza/kMmZ3wNfhkedF+nsAlO76Cff
PTZ5KB6vtRKf7Ndtg/4ynJw0q4PFT3gIg+QdHSWeZuYB+N6nujwKp3RYamKRqM9p
SJC2iYBI3wl3RJ6W2tAXFiQxHgs1pDQIJm8cAFyy0wbE/xBaQDo9q0sqZ3qICTse
35a1pPDl7voHSGetkKvIvWblBXTzjSW8z2OezRmSFS22OtIS68bvT+taEDxZfnbt
XIBkpAxhXeqn4kl5yh357T+GVF/IhMWXrknpKSxUGb6HKKHL6bCI/CKdqazEA9K1
ICfEbt760rLoHuxqHRermIIWwEdZbYMD6m5h2bbYasZk9ht1KJH5pkBP5DvtGJwX
zevseIDJo6Cw6KNNuOEjZnv5eynqmA5vWQ9kr4E64T4iauIEMEok0twBiJGie9mA
aWaMr+HeuJDGo298FGrE0b3bkVuaEvOyK3GXIYGscejrtWFC5LpwmGxQooN1gexR
Ju09K/1Rc2SCl24bfGQu
=jCxP
-----END PGP SIGNATURE-----

--I+QmG5g5EzYJzIBt--
