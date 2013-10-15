Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab3JOIqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:46:19 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:43046 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3JOIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:46:15 -0400
Date: Tue, 15 Oct 2013 10:44:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-bcache@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 14 (bcache)
Message-ID: <20131015084359.GJ7856@ulmo.nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C3EC2.20404@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdJFN6SSISdF2ksn"
Content-Disposition: inline
In-Reply-To: <525C3EC2.20404@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdJFN6SSISdF2ksn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 11:58:10AM -0700, Randy Dunlap wrote:
> On 10/14/13 07:48, Thierry Reding wrote:
> > Hi all,
> >=20
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> >=20
> >         git://gitorious.org/thierryreding/linux-next.git
> >=20
> > A next-20131014 tag is also provided for convenience.
> >=20
> > Gained a few conflicts, but nothing too exciting. x86 and ARM default
> > configurations build fine. There were some build failures unrelated to
>=20
> Maybe you could build allmodconfig instead of a default config
> for more better coverage?  I am seeing lots of build problems.

Ideally I'd be able to run allmodconfig for each merge, but I have
neither the computing power nor the time to do that. I can add
allmodconfig to the set of configurations that I build after the final
merge, but I don't know how much good that is if I don't actually have
any time to fix them up.

Furthermore I'm beginning to think that perhaps we should create some
infrastructure around this that would make it easier to submit requests
for build coverage. Quite a few people seem to run autobuilders, so if
all those could be harnessed to build linux-next (perhaps even on a per
merge basis) that would give great coverage.

> > the merge, most of which I fixed and added as patches on top of the
> > final merge.
>=20
>=20
> on x86_64:
>=20
> drivers/md/bcache/request.c: In function 'cached_dev_write':
> drivers/md/bcache/request.c:1076:8: error: 'struct btree_op' has no membe=
r named 'cache_bio'

It's quite possible that I messed that up during the merge. The bcache
conflicts weren't very trivial. This one in particular seems to be
caused by a commit that went into 3.12-rc5 and one in the block tree's
linux-next branch.

Thierry

--sdJFN6SSISdF2ksn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXQBPAAoJEN0jrNd/PrOhX0kP/0x+WYPwHV9ZzDrXa2rIQSO4
g3eUuaHLPzYZPX3x8BQZ49IKNdhukFvG/neI72raZ7k5pC+zBjiNZGGEnjVV4bNB
P4Tf8jdjBnlfQWTw2a9snxF6U7Gtel34ZOvChbOQnCTICtfdV607BY0cuhuHMCHO
HldT7jpFXIRVj33K6BsLGCxt6ZbMPDyYkhXvjFqEJn+PnmDN786hRuTHxCLNcrE0
10fBN3HutJdLhYNyND/KKc9z7t1qu8ZN3qEzV1PB0d0t1Wpp8xFBnCCx+0GHe6Hp
u+jaKjrfEMmhXOD3BawDczU+8CnAvK+dKNecdzeA+16uqTDtwoC4Pyvc3QWbqNAg
Cqu2FCnI92kwyXkH6OtI7WcYzFj5HS9tlyM0cVoMoUdxJKS9A1gR+ON3rCkkbI5U
x9dYGlhxhAEc2BFV+kt3Fj76AmxI156A4EnsNelhkHWMqhWpZ4YOgIpfl3tyzC17
EdYiZ0A4fHsKC8g2Fc039/vSmHkS8zt2O9suSaqePkbTLaLZLbIdBNqMYLhbN/MB
Jrqwa+3ox1zVW1jBCKL2KR1GfDmRpgkzLVabuWxkFsv8J/eFVogxNaDEC7o5I5SN
s/zv9gEj5fsh4l7fsyy14BIvEW9u4p8eLxpoKEPulM193dN8r8BuRK8sVeNBK626
UBKU1PxAfk9y2p/cbcuC
=2Yvo
-----END PGP SIGNATURE-----

--sdJFN6SSISdF2ksn--
