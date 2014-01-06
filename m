Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaAFRAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:00:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47977 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbaAFRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:00:41 -0500
Date: Mon, 6 Jan 2014 17:00:28 +0000
From: Mark Brown <broonie@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140106170028.GJ31886@sirena.org.uk>
References: <20140106124225.GQ31886@sirena.org.uk>
 <20140103160755.8153.81654.stgit@warthog.procyon.org.uk>
 <13465.1389026428@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xzwv1pm7hH1NAiSK"
Content-Disposition: inline
In-Reply-To: <13465.1389026428@warthog.procyon.org.uk>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/7] Fix up a pointer-integer size mismatch warning in
 tps62360_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xzwv1pm7hH1NAiSK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2014 at 04:40:28PM +0000, David Howells wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > you need to CC things to maintainers

> 	warthog>grep -i tps6 MAINTAINERS=20
> 	warthog1>

> I cc'd Laxman who is the only person mentioned in the file.

> I cc'd you who is mentioned in the "regulator" section and who appears in
> sign-offs in the log.

But you didn't CC Liam who comaintains the subsystem and for me you used
a random address from signoffs on old commits (which you will doubtless
have noticed bounces) rather than the address in MAINTAINERS.  It looks
awfully like you only used signoffs here...

> There is no "regulator" list in the MAINTAINERS file.

Right, lkml is fine there - IIRC that was prompted by another patch I
noticed in the series, or it could just have been part of the
boilerplate response for these things.

--Xzwv1pm7hH1NAiSK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyuEoAAoJELSic+t+oim91D8P/37cyctgI+Jzva4hycLseYg1
uLn0QHL6b59ywbB7SeirmiD2hanNU22/LdOaAqVHVNXjxqHZQD8rUQbyJhXOTl8i
rZ1wrA3a/42rgWVxZct4uWE6grJRVOBhVkluHexnc4q8twICv3XP3sy8va8mEC8G
TQV2Q4SpRvm/XzuT7Kpa2ERSGuqU8gs7gDFSLxVUzCovPN0x/cfq8DyA0PFmsJHO
nMHXNG+/5LQtWn0y5MJHMTl/+6SNNH6UHnYR/zhcUNhwCH3yWA/oYtKw1zkWkela
HdUo2qFW3Q5gjxHjpeMETFO/MlPG3VLlZTWHkGS4/SJf8c8P7Nnzoec4qmy5/nBn
7JaWoC8g4zlf6zv28uUAoDIykR46VQYtSIc4CMT4ESg0fYq+xbbNbwwKQp1qjGoK
RZILQtn5F3BjY4ql7mmbPxFSRQbGzC+Dp5uPg9tgxEvOdoTXZoXIoiOVNvVso8FA
bPoRAbX55a56lFJUgdyQOuNgLhYRFcxtfpIiLWoEIIwpYErv/GLIDNXREWNO5kNM
J33m46snItZ/6b/+NzGls9lcE0c+BSgacA8qnVK+5wMZrkYD8wZNDlPszxBOJ+Ho
ovSV5ovP2z84dCqmROa+So/vULKSSQnGZZ0BC2u/kBBU6M8kSlQgT7eYeDveUsod
tu+ylxDL0KtNN5xiXGIs
=+dYo
-----END PGP SIGNATURE-----

--Xzwv1pm7hH1NAiSK--
