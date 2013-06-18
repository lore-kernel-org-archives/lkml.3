Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3FRSHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:07:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44731 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326Ab3FRSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:07:38 -0400
Date: Tue, 18 Jun 2013 19:07:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "J, KEERTHY" <j-keerthy@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Message-ID: <20130618180707.GO1403@sirena.org.uk>
References: <1371549692-7361-1-git-send-email-j-keerthy@ti.com>
 <1371549692-7361-2-git-send-email-j-keerthy@ti.com>
 <51C0820B.4020404@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EC563@DBDE04.ent.ti.com>
 <51C093FF.6000204@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EC5B4@DBDE04.ent.ti.com>
 <51C09761.1020704@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bRSz5O7DOzi+nSIn"
Content-Disposition: inline
In-Reply-To: <51C09761.1020704@wwwdotorg.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property exists
 and then only request irq
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bRSz5O7DOzi+nSIn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 11:22:41AM -0600, Stephen Warren wrote:

> If the device was instantiated from a board file *or* a device tree,
> i2c->irq is correctly set. Hence, checking that value works in both cases.

The same thing will happen with any other firmware interface that gets
introduced in the future - one of the goals with factoring all this out
into the bus code is that it means the driver doesn't need to have any
special handling.

> If you check the interrupts DT property, that will only work if the
> device was instantiated from device tree, and not if it was instantiated
> from a board file; the property will never exist in the board file case,
> and hence you'll never be able to have a board file provide an interrupt.

Exactly.

--bRSz5O7DOzi+nSIn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwKHIAAoJELSic+t+oim9ylUP/1AUr53DWEVwamFjR7TwDjQN
eDvX4o2DHOh6xrqtwzjAj1oeTeWkqSA4J4nXc27cgf6ex94jporIagll1gzZzyhk
s9ZlUjMFSVpNobZxY/SJRpFq8wtlxLbhJhPtJXaeRVgNN17963VddkLW4BOvpm3B
XdHQXOWqr+ToBG3t5QILrFy5jcptVjXdzg3JtYyLXu5PWaed6mu3MkhwSjujZIp6
ickmMYv1+SJN3VsvR4WIaSlDhIrUbtE/RaIp6khAcDhLRHSj8R5snSvHC9OR/v9D
j3rPwiPhIMXRNkyVDIbvAmcJoSKgJRi5CaitKVWHW5Yt8qy7xEEAjbjZ3LJVi2tH
H/yqlnn+Sy07bo1YHA2MVoezJtnu2OUIQHkuJ5dc5clbzxOy35ooLqHs4iD8Gne5
YgZmV/FBhAIawxWZAcfujiuKCe6wjjcmFoTluIaZ4eqIgHBvHDJ+I82APCu5/CqV
+ONsZf7vFR0joBp353pedcWe6lvnZBVC3TWuG5XJWa4sCDnXNBmu372QCftbYPhe
xtl0Ljhf+fmgdU3CyrduAxbh5poDdlErFGKs0Ybi1cr7Xa2weMO0q+fgrgvNz0nc
JJ+IKsnUxp+snyROY5LqmqN+V5WB6xiyov9h4Lgs9Nxr9qZ8YkBOZhuYXgfT0TTS
W1woJK7uiE51cRfXe0re
=xRKR
-----END PGP SIGNATURE-----

--bRSz5O7DOzi+nSIn--
