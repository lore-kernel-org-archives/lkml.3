Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3IQKdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:33:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50732 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3IQKdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:33:05 -0400
Date: Tue, 17 Sep 2013 11:32:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130917103238.GM21013@sirena.org.uk>
References: <5237AB72.5020806@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OQhbRXNHSL5w/5po"
Content-Disposition: inline
In-Reply-To: <5237AB72.5020806@infradead.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fix fatal kernel-doc error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OQhbRXNHSL5w/5po
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 06:08:02PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Fix fatal kernel-doc error in <linux/regulator/driver.h>:
>=20
> Error(include/linux/regulator/driver.h:52): cannot understand prototype: =
'struct regulator_linear_range '

Applied with the first line redone, but this seems like really terrible
quality of implementation for the kernel-doc stuff - it shouldn't
explode over something readily copable with like this.  Should we also
not pick this sort of thing up in -next?

--OQhbRXNHSL5w/5po
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOC/DAAoJELSic+t+oim9UOUQAIQo1yvaHyPaipZZ+i/YLYAh
37g4DwMw1cyqs/ABnVNgMAlu2FsboXOSVglWmPBUzZo7Udnd45cht78M0m4AbcfK
EtrkA/BYB2fz2Fl6dP8zNvGOhODlkZNQjQPuH+UoxVwPkuZSahCIfROApRmt/Hzw
YJgvyYSfAi1xG9DApLLIvaJLylZ4JngFqU/GM6LQT57+cRY0Ci2Q8Ch/OzBi2swB
nGJHMm4Nz9A4qTEh2bFM6gfjaBJg+ElV4xenBbnDg3A8KdTK88y6RHOwcD1lN4Mh
1sSb69zxSC4JpmIYaT85rIbwGniUyQwhNEWx12cysLJIDH0fnAK0dvgWXNURKMhV
hvLndNnyA0NSq1VQtKKN8ZC0Pb3YvwLy7ysbDud6CTjAUt/+1cZp8KZDAujs1+7k
p27na1RsP0F0648nNMtiApKhAYoJRYfgV77vshT+zt1unAShymNcGIi1QhG1s1ri
dvYoqhivxGbOsxk+IgGpa3SwGUpmoOaUSkmxbhjutCXI8tWoX/aEKyup2GJFdkOP
odjMK/QQJscyMSSEvCKc01wgtp5Ke/Vp9Dcp3DeEJNJHzFedy7FvkBS+1BNcMsRz
AMI16rNrdWF6c2jz2NEkN+o8VMFQBxISXbAm3tJp7TOmt7omF2eAEZL/3hhheKFF
S02gP0TtSeZNfiUw8rUc
=edCG
-----END PGP SIGNATURE-----

--OQhbRXNHSL5w/5po--
