Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBYMQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:16:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51633 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbaBYMQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:16:03 -0500
Date: Tue, 25 Feb 2014 21:15:55 +0900
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140225121555.GB25940@sirena.org.uk>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
 <20140225115036.GF13246@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8avQlzbFg7ce/4Wy"
Content-Disposition: inline
In-Reply-To: <20140225115036.GF13246@lee--X1>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8avQlzbFg7ce/4Wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 11:50:36AM +0000, Lee Jones wrote:

> I am. The trouble with basing your patches against -next is that it's
> not stable, in that it is rebuilt every day. If your patches are
> dependant on commits which haven't reached Mainline yet, then you
> should rebase on the subsystem tree which they are contained in. All
> patches in -next should be based on an -rc or a released kernel version.

The advice here is usually that sending against -next is a good proxy
for sending against the individual tree without having to figure out all
the different trees - almost all of the time the effect is the same.
This only applies when sending patches via e-mail, for git pulls it's an
absolute no of course.

--8avQlzbFg7ce/4Wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDIl4AAoJELSic+t+oim9tG0P/1dXW2BxPy7OobLt60oq9a6A
FE9xj8SI3l4oPbApN39Uve6VI9ZgOhsNsPr1v1IDKof4/+0Xj2DI3em4B16DR7ud
HSvfEPPEcKvtKl1zJYiOfbA0T8hZASgkM+EK2HzikWMxdqVxsGIjVs6FY1rwvCD3
kfY/tCD4kcihoB9iPs2zQRb91T7ikmel7Hwu8ui+M0Ko7gEvh37MReBE2R/qTq2H
6D/EhU7PqGyEtSOVl6aPTS1YQ86Q8FFmBf4mNzmYUoLVGPY/gwCBB1zwT28xGgpV
cztJ7x47rAbElbQg13GeK/PgzU0MyqMpGid/J/9li/ZGF6T8tD5g7SSf4HpG7jTG
r3NvT3bMVOWrrHrV76gJVTRUWAprIshWpfmzvKGfmhkFyTTxc54ERDfdNHIbA9py
nNg2LXRJbHuu39sK9c5IU0gGaGgBocdlgDqSQFvdTJQwJN6v2gwMs0PT8Y6oVxUB
6DT+uTFP4gilBhn77vn25dofNJB1pjexEA2c0HpNOiRKcsR4NH83eItfep0bGnYZ
GdwOwmH3Np6TC+2rGO0d+qvznUwC/fXoGFr2kgQt4GT9GU675a18h8e3T2qEpPyk
EgEx6mGGYkE8mcJ4TY5aJ0Kii647muWI0lJZOTC+zhgxifqwsBW7MKJxZFEqFXlu
qqg3w7qsASMG+z48AsRZ
=gmEO
-----END PGP SIGNATURE-----

--8avQlzbFg7ce/4Wy--
