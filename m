Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaAINfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:35:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50019 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaAINfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:35:37 -0500
Date: Thu, 9 Jan 2014 13:35:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140109133533.GO31886@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-11-git-send-email-pawel.moll@arm.com>
 <20131224122455.GY30815@sirena.org.uk>
 <1389205531.23721.40.camel@hornet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G0V0RGA+h3BKS/P9"
Content-Disposition: inline
In-Reply-To: <1389205531.23721.40.camel@hornet>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 10/18] regulator: vexpress: Use regmap instead of custom
 interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G0V0RGA+h3BKS/P9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2014 at 06:25:31PM +0000, Pawel Moll wrote:
> On Tue, 2013-12-24 at 12:24 +0000, Mark Brown wrote:

> > If this change is making the operations hardware agnostic regmap based
> > ones then they should be being either replaced with standard operations
> > or standard operations being added.  It looks like you should be able to
> > use the existing linear map operations.

> Bad wording on my side. What I meant was: it doesn't matter what wacky
> VE-specific interface is hidden behind the regmap, not it's a generic
> regulator driver.

OK.

--G0V0RGA+h3BKS/P9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzqWiAAoJELSic+t+oim9Ph4P/RcjK8Bks4alej51WWEQwV8A
vCuYrk5xWiU7I0D6b75stb6LgYQcOQfG6svTq+OPDq/MKSKRkJzevyOsxxq/+d/F
cWiPBU7hdwX2W/Yas837TpRH3ivFuREVmMsbBWfVBTnQ/TOPbs4gjabduv7HQHpu
Xyvm4+J7Cn/BSzKAJd39YZZwES2AF+E+oI23vhWR/6jNWpU8XMTC8W/nNHvezbCq
GdmUfIjkbVotNn4BksX8W8PKTY9ipx+t9d5i7Evk/IgkDY6teGj3RGROToI9T6vO
h6+SVRsPk+c6NRg2ISkeUzMTxMXP0Y7TEcPU/cT4AFOHRvcLjgmRGzxlObRT+mri
Ryqib5gG99vIe3mjMnMdY7d9jIl+wYoxPE+5mZdeZ956/lGUi7vlH2269NYbl1xZ
U12iiBJW/Sgwm1PSRNW3qWwUd7uCAhHg1lGbgU2rHPbdwBgoH0DVy1hYO5vSzA4X
9mDCmgVY6xl3OkmOkD32wnZmT7oAOkpPyk1kkQKe+7nhhfB8m1V68oMqvbOu/XCb
9xb2wPJC1sMfq0TZqrMJzrjDrdrInlg/kHlXvetJyPB0X+mGpVkThY6I/DdnwxRz
myIndj4XiT41G1LFfLyHdQRhV1H1MvIqvfLwdNKqydQKBMPv3lkU8Z8dwSiqVlB3
0OdEeMFR+Hne+JMLo5vL
=MzAv
-----END PGP SIGNATURE-----

--G0V0RGA+h3BKS/P9--
