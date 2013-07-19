Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab3GSKDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:03:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60014 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab3GSKC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:02:59 -0400
Date: Fri, 19 Jul 2013 11:02:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130719100237.GC9858@sirena.org.uk>
References: <20130719135253.2689f6c0e42838f330b60df9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <20130719135253.2689f6c0e42838f330b60df9@canb.auug.org.au>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the final tree
 (sound-asoc tree related)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 19, 2013 at 01:52:53PM +1000, Stephen Rothwell wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

What goes into the final tree that might cause such breakage that didn't
appear in the earlier merges or is this additional testing that isn't
performed on the earlier merges?

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6Q66AAoJELSic+t+oim9FGQQAIO0mDQg3WnEU1inYScXI6+N
uGlczYUEuFjBQS4QuLKGLoJhzinXX24lhchB5dAik/wweHFYtbwsK81OxnRoEF+b
GbXuqkF1MvLt+AfY/SPaOgdWi6CECuS6+XpJYDbAWIR8UcHuRIeoA4FONOkhZ9Jo
dPkS5KP7hXnCmlsou5ncCmBLpYs/yfGhilNJAbvY4DOQfGOZnmfChcU7wZYSO0Tw
EWg3Y1QFpsfRahV7nJuU60frExnr78B5FRwxlZDaDwN4JtpR2Y9DnrKx7PC3l/4R
aCTMkiv1gmkEl0qK7uu8RdGIA9v6Uu/6csodES/wt5uye1qmSnBqnSAfx8X6GP6C
eISSsqhYKe97koXQSeX3Dz7xd52A7jiHlvu5xXhbNlKpwUFqG23WYJzvZwpRnW0N
9rJ1hgVCCq+Ru3g4GtD7pr6jV+sz23bB4BToOn3vv9UjIte+zE0AYbreG2RW8rjZ
J+cGrsl+W9ZjzD4OcFpaMi1bpxvxUdj7KRJT9EaINiGbYf3RvqEKVU9RhqYAauS5
1qwzslK1qxJ+T5RSOg3EfcJyzgyy9Ctgxy7ZcLV2lazrKRAg3v0GwEKSy2auuV5/
hod1JEYWlNF/yACaw2z9dCd/BHuyQm7d9Nv5V2pvZY3utMIDo77hqLLsJftuuuRb
1cxRJaQ1/FCPmxbRNO1o
=p2Pj
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
