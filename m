Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093Ab3JPQpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:45:51 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:64946 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3JPQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:45:50 -0400
Date: Wed, 16 Oct 2013 18:43:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 15
Message-ID: <20131016164331.GA12192@ulmo.nvidia.com>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
 <525E2257.7030604@roeck-us.net>
 <20131016155055.GA20211@ulmo.nvidia.com>
 <20131016163750.GA13416@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20131016163750.GA13416@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 09:37:50AM -0700, Guenter Roeck wrote:
> On Wed, Oct 16, 2013 at 05:50:56PM +0200, Thierry Reding wrote:
> > On Tue, Oct 15, 2013 at 10:21:27PM -0700, Guenter Roeck wrote:
> > > On 10/15/2013 07:02 AM, Thierry Reding wrote:
> > > >Hi all,
> > > >
> > > >I've uploaded today's linux-next tree to the master branch of the
> > > >repository below:
> > > >
> > > >         git://gitorious.org/thierryreding/linux-next.git
> > > >
> > > >A next-20131015 tag is also provided for convenience.
> > > >
> > > >Gained a new conflict, but nothing too exciting. x86 and ARM default
> > > >configurations build fine. I've also used an x86 allmodconfig build =
to
> > > >check for build errors. Mark fixed most of those in the trees that he
> > > >created last Thursday and Friday, so I've cherry-picked them on top =
of
> > > >the final merge. There was one new build failure in the staging tree
> > > >that was trivial to fix so I added a patch to the tree as well.
> > > >
> > >=20
> > > This build does look much better than the previous ones. I 'only' get=
 12 build failures
> > > out of 106 configurations.
> >=20
> > Thanks for running these!
> >=20
> No problem - servers are up anyway. Only problem is that buildbot and git=
orious
> don't seem to get along, and the automatic tree update doesn't work. This=
 means
> I have to trigger tree updates manually, which I may forget once in a whi=
le.

I do have a kernel.org account now, but I'd like to avoid switching the
repository again. People are finally beginning to realize that there's a
temporary location for linux-next on gitorious.

> > > Worst are powerpc builds, with 7 out of 14 builds failed.
> >=20
> > Yes, I'm seeing those too. I used to carry a fix for many of these in
> > earlier linux-next trees but since I haven't had the time to run the
> > PowerPC builds in a while I haven't cherry-picked it to new trees.
> >=20
> Are those failures due to merge conflicts, or should the fix be applied
> to a contributing repository ?

I think they are cause by some changes being done to the OF headers and
I mailed that patch to Rob Herring at some point, but I'm not sure what
came of it. There were a few others too, but I think most of the patches
I sent for them have been merged.

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXsIzAAoJEN0jrNd/PrOhQ8EQAJu/UgT9CaDYjbgIWppOmKeU
0Lr0CRWL+AHnc8w5bfx6oNHioZ6S5KutcxoXacejmbalNdUmJQMMukPKe9GtYcxO
zcyeTXrSYZrQZgLRKJtLHBWD8ltc62H4DOmlOX9Xal04FITnltQQ023o3D3XGD4V
WM7DLarHdh6YRpdHZSiSdiGcrwLbAbRgqQZ41Dmlb9tKnniPNVL3F0QbIAwxNTM5
ryDRs5eLcwaOHQEKN8VxCewQjUH8Mvl/pTluNe79Ryz2LPf9sa23qtcHjcxIkIxU
SQc+1kjzt9sdUcrHH/16ytMpBGPwrj+vJWWElCuEXTLRCWH73keEzEsAutJ1PGYQ
IGqWnn/Giugp8qEMUKvCxntBhUFW0Lu/Nd9AWigoV1udNCrv9ZMp0ZWoq4ecfhR+
Ax0N0zZFwSwdRSgcPlNvGt9voWGFFTEDCQqm8I+IN9m1wIPE71Nw/BS3YhWpgh5j
/0EGkafxiJnJmTLtXL/LUgniqhNUUIQRSynLf3fsozb+QsT8WqDGMd++RNKq+2x3
XbZ9SCPtIRCyR8+cRABTSq3RbIZuhK5Y1d74w7twtgJHUEVHUHL5aVpfxu9JhVfE
j97gZP0ZUsfzYNVZK+Lua/AGww6rBMPdfarYhlSWbIUyTOt7/FTiIBYaF/+KD1VB
nWxlcf85XvAQqaFK2JI0
=Fmpw
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
