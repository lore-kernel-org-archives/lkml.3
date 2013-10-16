Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab3JPPxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:53:15 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54963 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3JPPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:53:13 -0400
Date: Wed, 16 Oct 2013 17:50:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 15
Message-ID: <20131016155055.GA20211@ulmo.nvidia.com>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
 <525E2257.7030604@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <525E2257.7030604@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 10:21:27PM -0700, Guenter Roeck wrote:
> On 10/15/2013 07:02 AM, Thierry Reding wrote:
> >Hi all,
> >
> >I've uploaded today's linux-next tree to the master branch of the
> >repository below:
> >
> >         git://gitorious.org/thierryreding/linux-next.git
> >
> >A next-20131015 tag is also provided for convenience.
> >
> >Gained a new conflict, but nothing too exciting. x86 and ARM default
> >configurations build fine. I've also used an x86 allmodconfig build to
> >check for build errors. Mark fixed most of those in the trees that he
> >created last Thursday and Friday, so I've cherry-picked them on top of
> >the final merge. There was one new build failure in the staging tree
> >that was trivial to fix so I added a patch to the tree as well.
> >
>=20
> This build does look much better than the previous ones. I 'only' get 12 =
build failures
> out of 106 configurations.

Thanks for running these!

> Worst are powerpc builds, with 7 out of 14 builds failed.

Yes, I'm seeing those too. I used to carry a fix for many of these in
earlier linux-next trees but since I haven't had the time to run the
PowerPC builds in a while I haven't cherry-picked it to new trees.

If you want to give it a try with those fixes, here's the commit from
next-20131009, which seems to be the last one to have it:

	5a7a5211555a68a3144aa35015684e3a156cb11f powerpc: Fix various build failur=
es

I'll see if I can make some time available to add these in the next
days.

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXrXfAAoJEN0jrNd/PrOh5QgQAKsIh83mywBWd96dDm6PIebe
QQ8O9k1H2V73DBz1Wmj+rSjnNVlLrficiK51WKKZMsQWy/cY9UWz2m7OIeZKjwBS
kOw2tn8p4i/XUakE+ZrAI8xkKz8I6PsB+EaiPqZbhmJ1cnei7siEC8kTLSH+kmOc
ohL+QIch3X9W+F1uz7rgtbofsIkis44MpWPfg/tBjpw9fsJaUy9xlt7OTK4vLiOs
rS8n3BKk6b4SfuNud5odb6V9Bx2V2hddyJTHauUoGpaRhzGUfDt7RHZMr3XRLpgv
SQ369Lh7YnKdVvb/71NjMabrVIg6dS/2/eud7gSnfccjYW+jjpIX+e2RD6BoU8sg
/5Gm7vlv7XkrBLNIIEu2dQw2ca0UXrl8zPmF+NJrMpO11iglBrWmwJC8Rzhjpm5A
dY9O1o70xS4md5zPn31sb4kkmenXaXaaksyrLi3JTwTUwjxOXHWJGL4VczBu6NN6
alSp6F9YzrKFe/2z42Vsk7l+3LvWMe+7YOhTtRx59vFoegeVRxR77nGinP+PAVmt
wt6SgiLIyZ3+z4m2OMlBr4dP2rTvRk7g14++8TFPjqXwIMHnqh6Mnze/thmVuxde
MVc20zb5WNR/GarA0b+sRLPvUECrgdToMoRixsZw13efkzqiXYy5XeXgdFtW272a
WRpYj/QfXGsemL6HcJog
=lk3d
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
