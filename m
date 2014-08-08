Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaHHDVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:21:48 -0400
Received: from ozlabs.org ([103.22.144.67]:46641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbaHHDVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:21:44 -0400
Date: Fri, 8 Aug 2014 13:21:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
Message-ID: <20140808132135.47e16442@canb.auug.org.au>
In-Reply-To: <CA+55aFy0OFQ5ncwHwpah4xwxuOuMEWL+w6Dv-akTFnogpLo1yA@mail.gmail.com>
References: <53E20F1E.2080606@nod.at>
	<20140806212720.66dbd58b@canb.auug.org.au>
	<53E21186.3000702@nod.at>
	<20140807102823.7a743bdf@canb.auug.org.au>
	<53E32C5C.5010103@nod.at>
	<CA+55aFy0OFQ5ncwHwpah4xwxuOuMEWL+w6Dv-akTFnogpLo1yA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/aYcb.0iqbNNUc2fOzR=SUL_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aYcb.0iqbNNUc2fOzR=SUL_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 7 Aug 2014 08:53:56 -1000 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On Wed, Aug 6, 2014 at 9:35 PM, Richard Weinberger <richard@nod.at> wrote:
> >
> > It would be nice to see these rules written down somewhere.
>=20
> The rules have been pretty clear: "don't rebase public trees".
>=20
> That's always been the basic rule. There are _exceptions_ when
> rebasing is the right thing to do, and they all boil down to "lesser
> of two evils", but the evils really have to be pretty big.
>=20
> Possible reasons to rebase:
>=20
>  (a) It's not public yet. You haven't pushed to kernel.org or any
> other public site, and nobody saw you do it.

So this would not be in linux-next, so I don't care :-)

>  (b) You *really* screwed up, and the downsides of rebasing are
> smaller than the downsides of exposing it.
>=20
>      As in "oops, that half-way commit doesn't even compile or work at
> all, so leaving it in that state will screw up anybody trying to find
> other bugs with 'git bisect'"
>=20
>      At the same time, if you do this just before pushing to me, maybe
> you should take a step back and say "oops, my tree was completely
> broken, maybe I shouldn't push this to Linus just after fixing it".

And this is fine but shouldn't happen just before sending a pull
request (as Linus said).  But may also require informing anyone who
depends on your tree (especially if that other tree is also in
linux-next ... otherwise I could easily end up with both versions).

>  (c) You want to clean things up, and you're not even remotely ready
> to push things upstream, and while people have *seen* your work,
> nobody relies on it or uses it.

And this should not be in linux-next yet, so again I don't care and
shouldn't see it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/aYcb.0iqbNNUc2fOzR=SUL_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5EJEAAoJEMDTa8Ir7ZwV+BMP/iOP+hmBdpp5FtfdZ+LD2IS4
8i2TgQdxgort25B9/jBkiA7XI4ojZyeFwWHZCLZsXhYHLpnDFzwMHSc4fTVn3dV8
pysRsVbS+h6bCXV4csVIWfxEMvwA6ltPJ96Avqj0W4wQaWiZa54iH5KLagmVtPbK
ZoQKd+au8Dt7wbKJHHoasBxxi3XK59RgKLx4/sUXC/MVI89ebu1YDTG6QCHIvD50
pA6lzl2LjGU2wykTce8Swe4SkKp+sM5y0N/pp1RFfjqWAyOg63vDYEYSNY8XgXGs
3H1UObfE2i9F7dgNLIUYBlmEmNm9MfCJQwpoyVgLsFOunl8H4SqIlSNVoZPjlL5I
AKHLjFI1wCxPAr/RQlHJzVr+AWLFom3KYX/1zmIgwURMWcLpoARixs5Qz4icAI/x
2Kprbxc2OTDZdkIqE52JOr47Q2QIfHsVBJQF1CIVbJW7N4hFicmCHRasdXF7XCt5
pEWzCGwBE3lhUFe/LKyMTt0bDPFfuMa3LqWQ1MtumFAmohkhot7HMhkHWjEizYQ1
E17Y44iFCLaMMlmTSHWkgKzgcsKq1N+0fiINZPU0UFtC8Ywo5N8puuA9fwvSCh14
q7maJPGhN/d142KJN8pb4aqgAYhvIbOy4Jmq5n05QSI3XLcIfxbcJJPKaza39KPj
75f3Zw0vmACvN9dahIb2
=4sSH
-----END PGP SIGNATURE-----

--Sig_/aYcb.0iqbNNUc2fOzR=SUL_--
