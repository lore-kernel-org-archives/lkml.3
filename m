Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3KZAjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:39:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54062 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3KZAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:39:43 -0500
Date: Tue, 26 Nov 2013 00:39:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20131126003919.GT14725@sirena.org.uk>
References: <20131125174037.GR14725@sirena.org.uk>
 <CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z1gw0Ba8VHj8Ap4r"
Content-Disposition: inline
In-Reply-To: <CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regulator updates for v3.13-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z1gw0Ba8VHj8Ap4r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 25, 2013 at 01:10:01PM -0800, Linus Torvalds wrote:

> Btw, I suspect you could/should have just used an "octopus merge" to
> merge these kinds of small independent branches in one go. Just list
> all the branches you want to merge for one single "git merge", and
> you're done.

Yes, it's a more accurate reflection of what I'm doing since none of the
individual merges is a meaningful stage in development - either the
topics get used or the final for-linus and for-next merges get used but
not anything in between.  In fact my script originally started off doing
octopus merges but then Takashi complained at me saying you'd get
annoyed so I switched to the stack of merges.

> But it's up to you. I like seeing topic branches, and that part is
> absolutely a good git habit to get into. Octopus merges then have the
> upside that they then avoid having lots of pointless small merge
> commits to tie them all together, but they can make it slightly more
> challenging to figure out what went wrong if problems happen. So in
> this case, one option might have been to merge the three independent
> driver fixes with one single octopus merge, and then merge the core
> fix separately as a normal merge.

> Whatever. Not a big deal, I just thought I'd mention it if you perhaps
> didn't realize that git happily merges multiple branches at once..

If you're OK with octopus merges for things like this I'll definitely
take another look at using them, the enormous stack of merge commits
always looks noisy to me in the logs and pull requests and for things
like driver updates there's unlikely to be much doubt about which branch
it was if there's a problem.

--Z1gw0Ba8VHj8Ap4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSk+20AAoJELSic+t+oim9NEYP/Al76ygTI+uUeoF2bEs3Wmli
LsuNgI6lus6nIZY/glbBFDmZcqMh1KnsKT3h2VhLq2BtdJn6F8oi0jf6iA+PjvOm
8U22SZVf73cweZjhF3s/tPPc7mIMk1qCj15jKTHCUJn6OZfXYJsK6oL/REpKQp/5
fPOqIPL8w+ouKnr6vNSM2jmj56eSiIk22udBddhs7ZsiEYZaS96ALApK71LG4zcp
toax7QTIj9+PmkkC9QBBdNtacMhBlq9NyaD7+MuVtoUF/OtfSnIzQabss10FC6Oh
hE5VtN6yKi35XVFTuf9fNlJH/mcMtuw2TScT621EHMD5ks6xV9spAFfkUbVSQn2o
+MU19EcOIhiXWkmmdKoKvFSPoa70zzE2HhpGn0yGo7a2pKil6W76T8GRSy9l5IHx
6zgOym1SOOpKQnJ8acWmXo+qdXh83iitdkJ2x0MTl9tce9gMjaLHhWJsjR8cCKe0
kB14nRmr7XSqxyDjKB8l4Chg3jIFnOXEO3pSdqidlN3JQaNki9uMclN3C1xPXcZU
eIkpNi7jMJ3uRjwsdYzV96V/SJeYHS4YbHFeWS1w1tFr7+9yTPdgP4bT+B/IJehF
uxy2h0ToO14htIRgh0A8fAVrW2o2rMO+YXU7Xp/eAb+3xQiqzXKv7nSQKj7E9kss
6TW9/7yxg0CGFLNryhgd
=P2C1
-----END PGP SIGNATURE-----

--Z1gw0Ba8VHj8Ap4r--
