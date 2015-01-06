Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbbAFQDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:03:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbbAFQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:03:41 -0500
Date: Tue, 6 Jan 2015 16:03:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org
Message-ID: <20150106160317.GB2634@sirena.org.uk>
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
 <1419614799-5770-2-git-send-email-gregory.clement@free-electrons.com>
 <20141229154030.GJ17800@sirena.org.uk>
 <54ABC8A2.7090905@free-electrons.com>
 <20150106120012.GW2634@sirena.org.uk>
 <54ABD474.6060403@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GhOjTe89cQfBPqWP"
Content-Disposition: inline
In-Reply-To: <54ABD474.6060403@free-electrons.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: core: Add a sanity check on the
 regulator_ enable/disable functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GhOjTe89cQfBPqWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 01:26:28PM +0100, Gregory CLEMENT wrote:
> On 06/01/2015 13:00, Mark Brown wrote:

> > This really only applies if it's likely that some thing that always gets
> > used if it's there might be missing which isn't the case for regulators,
> > it's not at all common to have power supplies that might be missing and

> Well the pattern the following pattern is very common in the drivers using
> the regulator:

> if (!IS_ERR(regulator_pointer)
> 	regulator_disable(regulator_pointer);

> So for me it was a good hint that we can factorize it.

It is?  It shouldn't be...

--GhOjTe89cQfBPqWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrAdEAAoJECTWi3JdVIfQ2j0H/27+wdMimsjGY/cahnajFqfg
DJwWlqOPFScKPJnHvf0UoIabaVEcyDrJKGUJ57PbYyIBrXF4iu+YN9ySqO0RSWrR
hBm4dJNqNVPs5entlnoYtpxCwmaTCuiaqJcFKToQan90vu5N+PfHgHB4uGRA85p+
2Ya6zScnJWMQNBcoZFILCE/6wD1ziuSNmQHA/+fNXITUTW01/HnXiImN/eSrul3n
yXLg25QujA5Gu/Qj9tzOcBJko8exceft5vn+O2b5JymVZ9NV/wZ5us94NGkVJzkS
V7O5GQ2N1QY7lpU4D7wyAGlD1eW0cBsXWUeK6J8XEFtVzLDW+AWqCru9MLlwPmw=
=r6/y
-----END PGP SIGNATURE-----

--GhOjTe89cQfBPqWP--
