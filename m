Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3ILJbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:31:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39560 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3ILJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:31:50 -0400
Date: Thu, 12 Sep 2013 10:31:45 +0100
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
Message-ID: <20130912093145.GA29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-9-git-send-email-mika.westerberg@linux.intel.com>
 <20130911155120.GW29403@sirena.org.uk>
 <20130912092743.GK7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+W0ZOZq7uBvmp/5T"
Content-Disposition: inline
In-Reply-To: <20130912092743.GK7393@intel.com>
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


--+W0ZOZq7uBvmp/5T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 12, 2013 at 12:27:43PM +0300, Mika Westerberg wrote:
> On Wed, Sep 11, 2013 at 04:51:20PM +0100, Mark Brown wrote:

> > I would be able to have this and the other patch in the SPI tree in case
> > it overlaps with other work - I'm not sure what the plan will be for
> > merging this stuff but if there were a branch which I could merge into
> > the SPI tree that'd be good.

> I think these two can go via your SPI tree as they shouldn't have
> dependencies to the I2C tree.

There's all the driver changes though - it seems best to push the whole
series through one branch so there's fewer bisection problems.

--+W0ZOZq7uBvmp/5T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMYn+AAoJELSic+t+oim9D4IP/3Oe6epbIeARC39Vkzr26jN0
rxjxcFbCzualc1nLbwtzPyp25JcGRKmXOu3FZ3OnM9yAE/NYY7MZp0u/EYdUZeWv
6NUNa9ktaih/7NCI940Oku6jCVJ0I+wWSzoqmS7zd8HGKPmDzTLDpOkAoPPGtvLf
ZM0nlI1KZgMbvnSWnwKsJam9e7sbI+XBIN8SANSQMQuJ8NNNqcwhcyHIKhv7hwl0
1a20bHjGoAVnJd/vAmZMqn9Dt0ho3iu/u19c78m1Ouyh5pUH7Pj3pzrdb0CJ36cr
67SeNjnIciVQoRg30MKWPNF77uDMpeRcis0acPNawJIh8nv/4VLScicv5kpfUUA+
V9f8R8hWFtNMlY0Xr7UA169xqq6H35hKKsiJyDKhpxFwU1ofCH4yK1dEY6TA0apP
sFujdVA3pYZM/02ll0bqiBdGsaDj/p0intiTbef0+51tXGDMsGGOBQmbScQ0j26k
aU3MdId3iwbzOu2z0mU5fT/RM/b4x1MghS4mdr+DCZacpyL0JuK/VK6v5t88vR9S
EdmEeqeCA5gysgv3fii1OT+v7gn1e7D8SZoYZZZlUlrp6NpvaRGBFeRGAkiTh67G
N2NhB+5OyDelknQZFYJ0ke2FIddkYz56MdTjUi9PMhmf5TjQ+KA0uiabTUCFc4Fr
gKFN+NzG5GC7Q+b07Yed
=/6T0
-----END PGP SIGNATURE-----

--+W0ZOZq7uBvmp/5T--
