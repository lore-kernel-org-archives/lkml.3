Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaAZUmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:42:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59731 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaAZUmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:42:20 -0500
Date: Sun, 26 Jan 2014 20:42:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Message-ID: <20140126204204.GI11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mlxBsilMljZ1v4XL"
Content-Disposition: inline
In-Reply-To: <20140126211357.6fa68909@endymion.delvare>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mlxBsilMljZ1v4XL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 09:13:57PM +0100, Jean Delvare wrote:

> Me, I really don't know. I seem to remember I tested Wei's patch set on
> an emulated ADM1032 chip and it was working fine. So maybe it depends
> on the kernel configuration, or something changed on the regulator side
> meanwhile.

The regulator API hasn't changed here, probably the regulator API was
enabled when previously it was disabled.  If the platform doesn't have
regulator support either natively or via use of a firmware interface
like OF then enabling it is going to cause problems since no supplies
will be mapped in.

--mlxBsilMljZ1v4XL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5XMZAAoJELSic+t+oim9Zf8P/0LV4QrIbu0RRIpoiYiAMHNt
dsmEsvMo+zuwpjTJlgaNFyo7ZWz4DZNcWR8azCBJEj1RNItZcTsDUnaQgJuGWbf9
3+wDMaZzEzB9lBQ0tKLu7uciVw6RFfdTS0FYs0mMbOTatmd0QMgKNWHu+Vguu56G
6cuyIqwUDIaG5C7YwxZTihP9wM06Nvtz1MRASkxLls3Ae5/QOaV1tpJD+jtLdcE4
Kix62qOTEY/1q8tFPk0iSL7wLXUDVXWoMZcZQLe27OxXPd19nwgCk87laK55cvQQ
8pNZCJObsJr/l+QOSO1+d1exVlib2YleI7jHE0G++osXQpiOy/wbpIPkFI1hmSyA
ZE/CLKEkCj+6BpXUKHPBnj64t5AQGNG6sPuGJLSY0Ol51l05yjyaX8NTuR8VxyV/
tACbE75Bfww/bB1BGD0YqCPWE0EYWLcC82cPhNynt/NEELopQIASJ1XSLSjZN7wV
lbucAedErHhcZA2ANwYdu+22Y7lhMexT6fvNopWaxRwaYQ86xAGJ4kM/7d3facDY
k5eTwq/VXOdmdTjl3iKfXFPQgXJetSVxtGJ/I5h9/0lx1o429yQu7Fspypp1CbA3
d6d1jYEVxntF4ERQ/qhQXntvjNugwRboUptS/lPQC8qgSK/WdJ+bChjcAA2XuWwI
bVVjqUdiyVf1Uix3IKVi
=9/Ae
-----END PGP SIGNATURE-----

--mlxBsilMljZ1v4XL--
