Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaDKVxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:53:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50768 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaDKVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:53:10 -0400
Date: Fri, 11 Apr 2014 22:53:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140411215302.GJ28800@sirena.org.uk>
References: <20140411103807.GQ6518@sirena.org.uk>
 <CA+55aFznxvzfqa7OM0VoQ337kVYQ0hSjkqC26sxv7mxBuX9J-Q@mail.gmail.com>
 <CA+55aFxGbTdk-0mRtrYCRLJ1X6hbbrmOvKpgupA+4X1Cpoj=OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huG+SbfbdD6eblZQ"
Content-Disposition: inline
In-Reply-To: <CA+55aFxGbTdk-0mRtrYCRLJ1X6hbbrmOvKpgupA+4X1Cpoj=OQ@mail.gmail.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regulator fixes for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huG+SbfbdD6eblZQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2014 at 01:32:59PM -0700, Linus Torvalds wrote:
> On Fri, Apr 11, 2014 at 1:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:

> > Not an immediate problem, but have you tested just adding a simple
> > "git fetch" from my repo to your scripts?

> Oh, actually, the problem may just be that back-merge you have. When
> those cause multiple merge bases, "git diff" can no longer reliably
> generate a diff, since there is no clear base for it. And then "git
> fetch" to update my current state won't likely help, since the problem
> isn't that you don't see my previous pull, the problem is that the
> base isn't unique any more.

Yeah, I'm pretty sure the problem is the actual back merge - the
shortlog is doing the right thing for example.  I did in fact have a
copy of your merge in my tree, that's how the shortlog turned out right
in this round of pull requests.  I just need to arrange not to have the
back merge either through being more sensible about what I ask you to
pull or by improving the scripts.

--huG+SbfbdD6eblZQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTSGQ7AAoJELSic+t+oim9YDEP/2hCAK3TSQO1R94Lfoc0C6CT
+HbY6FpR8otWtqf2pc9AV8WXjV8cNKNfvmrBYKEei9MjLGv+RevbvNmwF2fngrfq
frqCK5Y58EFYP3LoFkAlP901y4SLNOMHrGlCyqodz5BTKT2e840RdbCZiaUYb/7O
szDMAT4YVTcJi/iCgv6DmW7QHQV9n0OrEBfhbTQXv1ZXLsX2OnwuzvsSyc3S7c0E
170X7KgV7mj8OpxfWLSqd+ruF1pKtpOOIlNESifYfwlRNaWHt50cK7a4jSKsGPu1
Xp85hJv5az/HdUDjI8CACwIbVNzBGwlpcWMSWvdnu3SL7Vk9zEOlJKiHmM9vPcT8
wX4snRFjkxvkb2M6i10f0rkffJT6Vu2h2UzjLSmQ7/MlzBaUA/uh5Uk17jbdZ0Jk
TRo9Lqkkl0VkTtGL5ES79CpY1/U4gOx4uU3ILaDB8wuGdg11l+DyFO1y+OWXLbnK
6Ntk+e4ji0cESSThGCY0SksPZk3neCrtlLC5KzuCH9ZfE2LaE4Ea8sJOPfo1Cuky
+WSR36N097sORVViIpCyUOOFVIXLtlgF9myaXi3XnJxxwtsQiYead2gkRzcdHyIx
Ep+iUatbXhKEdquHupfUzumRn81eJt2L/z+9F6s0kIp40pkUns8gIN8rIf9fOPYj
guvMz2N4FVyELYdH9Iz2
=vXtc
-----END PGP SIGNATURE-----

--huG+SbfbdD6eblZQ--
