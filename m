Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3IQTYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:24:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55221 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3IQTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:24:21 -0400
Date: Tue, 17 Sep 2013 20:23:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Message-ID: <20130917192355.GK21013@sirena.org.uk>
References: <5237AB72.5020806@infradead.org>
 <20130917103238.GM21013@sirena.org.uk>
 <52388CC4.7040101@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9SzJfJEKNI6APITJ"
Content-Disposition: inline
In-Reply-To: <52388CC4.7040101@infradead.org>
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


--9SzJfJEKNI6APITJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 17, 2013 at 10:09:24AM -0700, Randy Dunlap wrote:
> On 09/17/13 03:32, Mark Brown wrote:

> > Applied with the first line redone, but this seems like really terrible
> > quality of implementation for the kernel-doc stuff - it shouldn't
> > explode over something readily copable with like this.  Should we also
> > not pick this sort of thing up in -next?

> /** means kernel-doc syntax and it was not in proper kernel-doc format,
> but maybe it could just be a Warning instead of a fatal Error.

Yes, that's what I'm saying - it really doesn't seem like something that
should be a fatal error, that's far too fragile.

> Ideally we should pick it up in -next, of course, but I doubt that anyone
> is running kernel-doc on linux-next.  I used to do that, but there are
> too many errors/warnings.  I suppose that I could just concentrate on
> (fatal) Errors in linux-next and ignore the Warnings.

Could these checks be added to Fengguang's tester?  If nobody's looking
at the output (I've never found the processed output useful myself) or
running the tool then it's a bit worrying...

--9SzJfJEKNI6APITJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOKxIAAoJELSic+t+oim9RjMP/364kI2wVS9KZ2a6O0FMdVwj
vo6MuQi+o1gIsOGsP249P4L1zjY8eAJxJ6kK/k5qe3NVfvlI6szWE9kYUhuUoZC8
en+HlW7hrBxxZKS88jrS9NAusGJ511ZCCHbXPMGeYGnUVXImNXQVGS0YCd5Ysgea
DYvAJlQ2uIyV2M82p9niBG2a8a3yJYUde4Q+NwwOj35dHoSpnhD+Knzpih5+b7Ks
qcXkhy844xcOZnOTk0HqKmYKWSAXr1J7T7Vvj4Ud6wRSET7pNQZWQjhqhaLxojRc
OUZsBpz13AkoPDs7qb7iQUgqyiy7hDm6on3muDiOYNv2ftOodFX8/pqEr4KgEcdW
i7xClK3JvzW/fq4158bMQr+/LoowZqLmlv1pnRDyULyd5SoOX4RzAXoRprBcaGce
5cOODlyiJrziwQspGQ+7+LC4VnjgVcOO94yNY0kTgW+WWokYbamb3HmfGW39R2Ab
LAsive34P40YqExEgDyQ+flohmSwoJ/HOXYv2NRGEey5+RF7FkHVYDFORZd248hx
ZPWoCCMJX3mO2ssARwn+qee+N/2nj+HKVr645Fx4oP/Kro2f6O9cINS9+beI3D1j
1bG5ZHR57IPC7KiRoz/g/yWdNX2tv+oiBuTyk2jIt8sLMX4hYQVh5v3/cjzW4Db1
7H3MeZAgGElSOh2GPY+a
=4ReZ
-----END PGP SIGNATURE-----

--9SzJfJEKNI6APITJ--
