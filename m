Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3JLRW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:22:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56994 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3JLRW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:22:56 -0400
Date: Sat, 12 Oct 2013 18:21:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131012172150.GN2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xdWF/UuCWMRSqXrg"
Content-Disposition: inline
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Oct 11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xdWF/UuCWMRSqXrg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131011 tag is also provided for convenience.

There was one new conflict which has been reported, each merge builds
fine with x86 allmodconfig.  A few cross tree integration fixes are
still being carried but nothing new.

Thanks,
Mark

--xdWF/UuCWMRSqXrg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWYUqAAoJELSic+t+oim9xAwP/1SI3+YLofs0Cat9wD9wsXeD
5NN1xoF3LCQugga9XnWD68qHQBkvYkyzwI/DBuJlL2vL3CzKR+MTmzem5Q8ftoiT
QDaoP1lc9GCNYntyl4YNT8p98O7Q922kNDWj+yCtqaAudxlq2uEw0ptB3XqpwyN4
qb57YlZKuoew+D6melRE8BnYPPa9GkummWwd+6XSroZuMGHVOz3Qux98c/BHgGJL
s+5S2//tW+o/sM96N/PFvGaxTzLKak95cTOSkvs8wY6cyzZlQlWwn4iYAzwWsgNc
hbyYYd9oKNL3BJDnQ6aZGN4OIsXlwJnDVDgbxxdVmu/fnx417KJtMUFzGH5NlIlP
mxTwXSnJ0405kxPuFqKHqHljfEGtUilNoZny8pKLwPwMUT7z0Iq2Pj8S8PH2KDTQ
bTs9VbgYx67eMSpm5rrFMLtDbNo1kffnDDfmMAv/uwQwIktqwIJ7v/2Zhnvm1aAX
ZR0yuBDU6XS8RGp0xthMpN6WW2lBSxZM2wliJjDus+IjMTgYakYOqZn70tHVbiUj
0FTyvLuBrwwNbYMk502n40KaOGWYJsmLarq6wvCEZqnswDsCxqYvvpgXS8Q+bsVX
mDZUhc3FiT2bu8Zyt8I+5Oheg6OlzZhdnlu7nsmp7YlWauLhHP68C2in0UtQzgJf
qHt+VJMHQ7ZhP2ZLz10J
=GV2B
-----END PGP SIGNATURE-----

--xdWF/UuCWMRSqXrg--
