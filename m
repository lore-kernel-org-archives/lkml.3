Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936342AbaICXtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:49:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49014 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaICXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:49:30 -0400
Date: Thu, 4 Sep 2014 00:49:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Message-ID: <20140903234917.GH29327@sirena.org.uk>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
 <53FB9DA0.7000301@infradead.org>
 <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
 <540651B3.8030400@infradead.org>
 <20140902232906.GG29327@sirena.org.uk>
 <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
 <20140903232149.GG29327@sirena.org.uk>
 <5407A68F.5090805@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nkinyqrdwMuqz198"
Content-Disposition: inline
In-Reply-To: <5407A68F.5090805@infradead.org>
X-Cookie: Simulated picture.
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


--nkinyqrdwMuqz198
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 04:38:55PM -0700, Randy Dunlap wrote:
> On 09/03/14 16:21, Mark Brown wrote:

> > | git am ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
> > | Patch format detection failed.

> > I guess either something changed in the way Randy is generating his
> > patches or I'm using a different version of git which doesn't like
> > them - looking at te patch files I'm not *entirely* surprised they=20
> > have trouble.

> Hm, it could be a problem with the Index line.  I'll disable that option
> in quilt and see if that helps for the next time.

If you try applying it locally with git am that should show if it's OK I
guess - I'm using git 2.1.0 here FWIW.

--nkinyqrdwMuqz198
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUB6j6AAoJELSic+t+oim928kQAJXvhXJ5UNfdvqzX1I0txJBC
r2X0rN8AZAi6DgwlSnyh5P7KiUOT8Mm7oXb3SpGMdpB2hvDy3uRtZDv4KcQmR6nf
8bSfjxYy5urugCIG8ZZNBAMiwjgs5IpRvOgoPRoLLxK0o65hQBBUfd3GVUJR0zMI
ToBp1YLPhzf07hjPOPcCm4Cgy0mEBeu4dNcyjJWf5Nf4Lq1nsJhJONu51uOekbEt
AW6R//7pRZSqRbW+G8j8tR/PiFx/9XXpXhkkwE0F8mcHpbOHolkcHjm21+k7DnwN
Uzb4tnXWEeFGVYGN3uHqrFSPZ43cO4ncR7ndjFJlzq7AWUxsE59leXvnTt0t1ODf
3NvbNqEpAIAy7TtBZOFtqL83HRXCYdO+Y6aEOdKsRFTiQNjclsGeHSGPEgq5zoLY
6iYVmiMIOhG8ZFDehQphgC/8bj8oPxVnDI1dOqLu1ovh2cxe8DD9Z23+XJ2cYsCh
aMI0pxsJeXsRGWJS3R6bPkOg5kR/wRoorMwfxN6ePIS/mhS0u4AD/9DkUQ8Fbwv8
N5TYzZ3sv/Kq5C+1C7eVoDx7r6N7/nuHlye1ynkVAITWoqdNf8EiQEp8uFxnwWkQ
y2h9YihnOeXsPHQ49ZMXGxH/1HmQgoF036IC5gWaFQcsOnB2qAqp/PLynuF0V/ID
vqYttLfMq+PsVIYRCErM
=miWX
-----END PGP SIGNATURE-----

--nkinyqrdwMuqz198--
