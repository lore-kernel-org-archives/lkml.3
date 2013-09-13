Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3IMMLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:11:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50052 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3IMMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:11:30 -0400
Date: Fri, 13 Sep 2013 13:10:59 +0100
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
Message-ID: <20130913121059.GL29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <20130913095950.GA29403@sirena.org.uk>
 <20130913101611.GA7393@intel.com>
 <20130913103152.GE29403@sirena.org.uk>
 <20130913115035.GB7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="27NCtaTw21bcrDcq"
Content-Disposition: inline
In-Reply-To: <20130913115035.GB7393@intel.com>
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


--27NCtaTw21bcrDcq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 13, 2013 at 02:50:35PM +0300, Mika Westerberg wrote:
> On Fri, Sep 13, 2013 at 11:31:52AM +0100, Mark Brown wrote:

> > Right, but this probably needs to be highlighted more since it's a very
> > surprising thing for I2C and is causing confusion.

> By highlighted more, do you mean something like adding a comment in the
> code about this or?

Perhaps, yes.  Or possibly the commit log is going to be enough going
forwards.

--27NCtaTw21bcrDcq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMwDPAAoJELSic+t+oim9KGgP/2LD68umUpEP+9jo0+S+6JeB
ZXaQamFK1V+u5dBPrfr55gnm3cgg9AJqUCE2iURJpl9JHhFK1GaBTNFG4VV9VVA2
2oH0du0z66UY5tg2m41e1DE7AtZbPb5vVe1PB3NlRArwU0k7/MIZY5uXz++3DwP4
PYv8rBbx8XKWmACPNKh8rtY9k3woVRm5fDwUeiJUru6OX8QILBrfFDVZoEy3TSz5
D3PE9lK6jqJCA0SHipn61qWQuuMLnkuYmnvhcK2B2/nUvPLKF/HuNhJMyFMkKzfW
Huz6uC8am5EQF+MinDpsNwd21C3TS81oN/86LKJ5LwJYznwSoR0FAVseKYUg59eJ
CUaTBqmTkVsw9R9CyEE3PRlUFAFA10fZ3E5yADEp2EY1KHluCWS1k0Z3u+TqP3Lc
/7FY1ITcthLOAolO5bHsm5egbXxqb4KI0XRLxaze2ztrLuGebwlPFpOsWjCiRDud
7T/pxb/86xrVLnLK7bRriVBQrlob/lFgyey7vTCKhqj3GdjJ92x/o4eKvOdDzaWB
p3O1WYPh5di3p0nWkYSM/LAU3dUx+Ot565VGxCDx6SKBW64torbFV4wZkLfrIggf
tQmSAE8YLQuqrYm95IT4FXZlsZOPpHOMDuzJrI6p3/YYwXUrgYvPplkm8VqWyyBF
E25+zh/+e7ZKcgGyhFRP
=U4cS
-----END PGP SIGNATURE-----

--27NCtaTw21bcrDcq--
