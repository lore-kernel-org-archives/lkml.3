Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3JJWzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:55:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35647 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3JJWzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:55:13 -0400
Date: Thu, 10 Oct 2013 23:55:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131010225507.GY21581@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i4WgBwpUkbQcesZD"
Content-Disposition: inline
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Oct 10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i4WgBwpUkbQcesZD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131010 tag is also provided for convenience.

There were a few new conflicts which have been reported, each merge
builds fine with x86 allmodconfig.  A few cross tree integration fixes
are still being carried but nothing new.

Thanks,
Mark

--i4WgBwpUkbQcesZD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVzBIAAoJELSic+t+oim9s8MP/RQXxvQjzKaieWM5+rHjjIC/
qjhLhrDnychkzZRItGFoLp29Qp9gh+x67xtHJyCUEHPYpfnGNYozS8gEchai1ojK
H35Fe9bou925TPZBHlqD0hP4eWI5V5FRPW46sPDZkYP1y2JlYEzrJTVoD6kNx0Ut
oyZAJs5FgYxv9IJB4Bu/mPMcR6ruY71/0ik+77CTcFrZhdI7N9sLWDCr7GCjq6+x
FfCJL57UF4N7rI2pk4Pj/lJg68X37tbdjNRwSpmbp07K7zkytmQMHkwTejwAOxKy
jzKKHIUNoDFxc2m5qrKHG1fv78S0agzXegT0aDr9VD4x39tufCcRMpjewTvryd+O
iLi1iqrHGpE22kCb1SWZ0t2oroShIOrfODjghxo99cJ6mNPuhY1v/txI0LodUAZi
t0Et/XTVXFk6TSIBRvnSm1yDrzlDi1tLkKgGkdX5c9LRptfhcYnSjVyQyxQWK8B+
1L3ZiSmbaItF6ZoFyzuK/Gqia4bFzDwfzX2bKtGpGPPMAQcj9XcB2povkUCYkyO6
TC7exw94FFB3l4S4UFB9uLPiaiIwPtvmdOAak7E25UVXX7I2BBxP874C+4AsWRP3
C/GsEZncWv0k9rXeIybpngvJn5Ei4goWIgUz23/v07gz4NvcBsuEa1bRZomaibMz
d+SlaagluZiGpScu5jwx
=P0E+
-----END PGP SIGNATURE-----

--i4WgBwpUkbQcesZD--
