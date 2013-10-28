Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3J1IB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:01:29 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:65122 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3J1IB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:01:28 -0400
Date: Mon, 28 Oct 2013 09:01:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: Tree for Oct 25
Message-ID: <20131028080109.GE6629@ulmo.nvidia.com>
References: <1382713426-2680-1-git-send-email-treding@nvidia.com>
 <526AF150.1030004@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2E/hm+v6kSLEYT3h"
Content-Disposition: inline
In-Reply-To: <526AF150.1030004@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2E/hm+v6kSLEYT3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 03:31:44PM -0700, Randy Dunlap wrote:
> On 10/25/13 08:03, Thierry Reding wrote:
> > Hi all,
> >=20
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> >=20
> >         git://gitorious.org/thierryreding/linux-next.git
> >=20
> > A next-20131025 tag is also provided for convenience.
> >=20
> > One new trivial conflicts and a new build failure caused by an incorrect
> > use of the genpool allocator.
> >=20
> > Upon a request from Olof Johansson I've only included fixes for build
> > breakage as a result of interactions between the various trees. But
> > since I've fixed many of the other build failures already, I've pushed
> > those to a separate tag (next-20131025-fixes). That builds fine on x86
> > 32-bit and 64-bit allmodconfigs as well as ARM and x86 default
> > configurations. Most of the PowerPC build errors have also been fixed.
>=20
> That's unfortunate.  The fixes should be part of the tree IMO.

Cc'ing Olof and Stephen.

Perhaps something like the above scheme might be a good compromise. On
one hand, many people are using linux-next for their daily work, myself
included. That implies that if linux-next doesn't build, people either
use a previous one that does build (so we don't get as much testing of
new trees as we possibly could) or they fix the build errors themselves
which in turn may cause potentially many people to have to fix the same
issues. On the other hand, if patches to fix build issues are included
then people might just assume that there are no problems.

I know that linux-next is a ton of work already and I don't expect this
to be done by Stephen alone. Perhaps people could collaborate some more
and provide a separate tag with additional build fixes and make sure
they get merged into the appropriate subsystems.

With such a scheme next-YYYYMMDD could serve as a metric of how good or
broken the various trees are, while next-YYYYMMDD-fixes would be a base
that people could use for daily work, with a set of known build fixes.
Perhaps it could even contain fixes for non-build issues, such as boot
failures, if we can come up with those quickly enough to make sense in a
linux-next context.

Any thought?

Thierry

--2E/hm+v6kSLEYT3h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbhnSAAoJEN0jrNd/PrOhoq4P/jcj1Ck3y4DBSHMqDBaFU68p
M7E5dhHI6B+tij/ZGx0kq5a7rS9aiUa4JbJWtr0E/9HiaoWGWwaKyvcnL7QFwTBj
X4asB9PBxmFO5/40q/TIUOOqx7KBLLIeu9NnOy3ku14AbYiGrKSJhAG91jUih1Oh
8UvYBxrMkj9wpbVNCbOo7zrQT/rEADl3mbhJSKcmL+bhSs7+Bo691/f+nHvrrXow
3SlLdsW579oTQCKmfSNtgz/oO9Fu0+QmfTMFmCZN0mbZA9TN/5Rvpj1gBR9qRpx1
pZmEmbZr7lm+ZyQA7dtW3HRUxtrG84WbkM+p+iEVMJvBGk7N95oN9ISORtu05EdP
zIm0eZIym6+agkCxf2Qs5qAREBU0k/9+rbbz+RslN/ymhpAXfI0wdCvIa53yIMqV
c2vqpIH0RwihwzgZuY47X5CAGhiBiX9qwbFyd/JXCmfUtMwAa+glcfeNtghUjGI6
tEl9BduxmGxNiGq4jNtwL682yphaLxFVjqXtLdJ3gPTZPGIKdJW8uzryVe3TZEf8
dpLsfmRqbaQOmdgiZVIku9GWgfZhuKINhvH+bWIC42NxPc0tJH8qIH8ibUZC8TTj
eeNrX/Znf5zM6cSDxuFBR9X7eOw8ImykOmYZnQXNdUTawqUndzG0OlAgCNQg6iQL
PuKMFjkBcZgISA7z80wA
=Ostl
-----END PGP SIGNATURE-----

--2E/hm+v6kSLEYT3h--
