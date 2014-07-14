Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaGNSQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:16:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37314 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbaGNSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:16:45 -0400
Date: Mon, 14 Jul 2014 19:16:30 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140714181630.GT6800@sirena.org.uk>
References: <201407140450.s6E4oa79016771@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k8r0khnpBuGu0wUi"
Content-Disposition: inline
In-Reply-To: <201407140450.s6E4oa79016771@krsrvapps-01.diasemi.com>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V6] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k8r0khnpBuGu0wUi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 01:48:45PM +0900, James Ban wrote:
> This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> Converter regulator. It communicates via an I2C bus to the device.

Applied, thanks.

--k8r0khnpBuGu0wUi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxB57AAoJELSic+t+oim9E3UP/iHT26wf+cDYjj6Wbh6HUgHn
ZAn9MxbgXyqZ54L7uSIFR6lZPNGBdi4ektnwP91rUDwcLErG8KKMVMhnaGgrLqBH
JqP4dczD0gED8rl+35zAxj5QzHo+K+oP/EZZVm7uGkkE3QO1fT/06UdyRjcBwNDB
JYFRGsgJ7Qyn9kEaHphREGxvFJyvb7mptIf1QUlcjVyp+BeMxvNH84zXESqvmFXk
16QoK4CvrlzAe8768REgwbs9VpBC1JKP18MMO1jdagvB01RMmItlzq7y9gz13SX4
k98UyUK99/+tvET0XhFyyDnpX/SMLNQzRbr8fTT6s/gKSfBcjCdbqt+BvZ8Pg5hJ
43+JJ/Rp4k5scrlGFjBswx9WUpc9amtTNxF9mpHpvhC8Ug/5Yqbo2cKydFSSdGEd
aKi2IYVAIRqLCpOkdz7hg525K83HGFXzDrBsFovqQLELPjpLOw68UG+EabBBtmTT
sVVbiVHPTublt6uz3ADDsMurE6e3UROuC+3XCDef8G4W+y9SFAJlZSGvN8USATob
dr3B8c+Z1Uy3cmxT6zyw5EJolUdyNdqQi6vLC/vpXzK0a66474NdAcjJ9ME3XrY3
vV9WE9D6FXKaWk+eYoNKYuNMkApe5Lk2zjOJiHRkFYS44dsLxw362tTLjfFSW7YV
dlYEHpIyOdNxCF8/aVly
=wulZ
-----END PGP SIGNATURE-----

--k8r0khnpBuGu0wUi--
