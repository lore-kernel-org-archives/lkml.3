Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3JDBC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 21:02:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38640 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JDBC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 21:02:58 -0400
Date: Fri, 4 Oct 2013 02:02:30 +0100
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Message-ID: <20131004010230.GI27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bmlge7Pg4VPvffji"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Oct 3
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bmlge7Pg4VPvffji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

Better late than never I've uploaded today's linux-next tree to the
master branch of the repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131003 tag is also provided for convenience.

A few new conflicts today caused by the removal of the h8300
architecture which I didn't report for triviality.  Several new build
failures were found as a result of running allmodconfig tests between
merges all of which have been reported and I'm still carrying the i.MX
fix that Thierry has been carrying.

Due to the length of time taken to run all the allmodconfigs I skipped
the defconfig tests; I know Olof has the ARM stuff covered in his
autobuilder.  I'm going to use allyesconfig tomorrow since that should
run faster so hopefully I can cover the ARM, i386 and x86_64 configs
again.

Thanks,
Mark

--bmlge7Pg4VPvffji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSThOjAAoJELSic+t+oim9coUP/2MWLFf5xVCF74dvN5XcX2xT
1k9pAc/8fJ9JhZxx2ifRknUlc4NxXgbkRoEry0toSXnONGTm02b2PEZl0nrAA9Xa
vPtHwx+LPkWpZ2DLxygBwzkEpkf7S78zphQmJMYBGiXLlJoCgpYYbJAOeY0jGQEz
ubUFPJxSemFZbWTf0/TZMzvxpZ151g6Q39TipwYBWl2Rc2OvBbku0kRBRMEoQyKj
MWjUmYoZeA7sPiBzxIDjGi8bAcUH9PRlcsgUxUnrREIUXOXXdY/vaPub2xPtmEU5
WxX9wdGddFXSO4qaEpCW/zN+RJHr6IpjlU8qpx8EGATwueu5XvZ2YP/j27Gj8EBN
HcaCItPd1ENgEwh9A8tEZbF6VOVGlDGIMdLI6Huf4GffRK28gmziD2Pte42NTBPu
m8cxOWWXwFsI8LJmY0E4zLKgJu4lDEGuDGssaN5QyNtfpVpiJTXlHuCt7frEjjOe
T7ONHgIEvpOC+avoCLqXW6EYpyIOXS4oSxkdZWDMyjVa2TfK7tFmYpIMqYYy+XtF
vMdbd8n9MvpQObeqqIxgJzvogvCJRyAwXSPqtUO/cjaCy4/phlECZkh6ERDEOqEq
EQIh4Wn83S2H2U/zXzEgDDVJOYGuwhQJnJ2YF7Kv+n5YCzusmNJfSH+plwzMeX9p
axToiMs23TXhCCUvdgO2
=5b5l
-----END PGP SIGNATURE-----

--bmlge7Pg4VPvffji--
