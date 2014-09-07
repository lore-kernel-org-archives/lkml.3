Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaIGStQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:49:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55840 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaIGStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:49:14 -0400
Date: Sun, 7 Sep 2014 19:48:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <20140907184837.GD4015@sirena.org.uk>
References: <53FB9DA0.7000301@infradead.org>
 <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
 <540651B3.8030400@infradead.org>
 <20140902232906.GG29327@sirena.org.uk>
 <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
 <20140903232149.GG29327@sirena.org.uk>
 <5407A68F.5090805@infradead.org>
 <20140904104201.GI29327@sirena.org.uk>
 <540A503D.20807@infradead.org>
 <540C9D19.5080201@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Content-Disposition: inline
In-Reply-To: <540C9D19.5080201@infradead.org>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 07, 2014 at 10:59:53AM -0700, Randy Dunlap wrote:

> The quilt-import.log from 20140829 says:

> $ git am --patch-format=mbox ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch

> and in the 20140905 git tree it says:

> $ git am ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
> Patch format detection failed.

> Are you using Stephen's scripts?  Why would his tree apply patches with
> --patch-format=mbox
> while the later trees did not use that git-am option?

Yes, I'm using his scripts.  I guess it's possible there's something in
his global git configuration that changes the behaviour?

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDKh+AAoJECTWi3JdVIfQRLEH/15UrCfc+AN5jjKbd40kQtnp
jD4QkwBHefxzL7j0N9VIiJgfYbUaBRuKqR9Nge0sRUuiAx71Da92Lkc09hVD0K6r
C1YdgCC3w+1YkBPibwHptjK+RRQKv5p8bwe1Mp4vex19CPwGT2bsdG/h+5UIyTKM
pLr8008Xre3ighsKIYVjQF9vHtfoNB29P/wq1CSej0p+Do4OnqHRwTTySutGznQa
hV28vSeaL11CNuzftXwVZXcgRMm8B6IbaNlcfiiSepJziYXt9rQokLy3wRrur9H1
eQiEZtr/a0XOGhhOZe/lGFQXsNK2c3mRZW1yImXj4s2MLuojBKbqbA+run6r39U=
=w+jS
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
