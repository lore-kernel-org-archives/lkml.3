Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3F1Nu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:50:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34012 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3F1Nuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:50:55 -0400
Date: Fri, 28 Jun 2013 14:50:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130628135051.GK27646@sirena.org.uk>
References: <1372426585.28529.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hLThDcvT216edA+z"
Content-Disposition: inline
In-Reply-To: <1372426585.28529.5.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: regulator: Is there any reason the 88PM800 regulator driver can
 not be built as module?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hLThDcvT216edA+z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 09:36:25PM +0800, Axel Lin wrote:

> I ask this because MFD_88PM800 can be built as module.
> So any reason REGULATOR_88PM800 must be bool?

No, it should be module capable.

--hLThDcvT216edA+z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzZS4AAoJELSic+t+oim9r9cP/0E7UNtx/GoJLsKAS/IKyihh
TKg9PxvLr9uOukoJxk5LDm912kbhZHEZOFDtOIUvlXKEoebpJsD0HOHfmMXkhYjy
SdpXTiuf8vcGqxsVGOPNFO+7lIvo44CZmnMf+da14hzUNw5hHgNINX/Unbsozq5q
iR20dXhwL1E+xn6YKzbxBLf1jkN0ddd8ksf6/nczmSMrlR1nHCqkdvhUP+EzjprR
wuRLW0wb0XNCpDETm8J3yNesyf+zdJWk5bVhMrPapArZ7h/uYW8ZDtfeTwWw/uFp
yANZrPkkbVCbxiJ4LygzvdXpdMjSOf+SDSw3CBJV2BFvfW0vJ3r+LV928Ht3MEld
RbJo5RJRNiwcmK8WPWSumFdeFCtvx93IN6t/pbd+p7GwAlEq6G2H0BRhvzFFL1C4
fLwTfZAV9Y7dgBzieqnypTolvUjBgzfHQx5bktZsVyaYr6KF9mZvoT3+vCP8iP9y
XGRFutPAywFiZyecwjBEHxc2qxmj7QOX1S+9xQv3z4QdMMRWUEIm/V87twUW63TX
EKWKw+jqvyPMRdQlKQlm+AdEEkLKRL+T8jFybwvVJ3mYWsfZN74l5vWeJJ7HLKLX
C4N7aWzsUCFJVDqu9/Q7vKA5eek8dBre8jcfQNYUqcZrHkzycUkOxH+FIoCHgBvB
+bS5Dd5iBCIJstYNdQ3Y
=RG4h
-----END PGP SIGNATURE-----

--hLThDcvT216edA+z--
