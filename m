Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab3CSWUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:20:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47244 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab3CSWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:20:12 -0400
Date: Wed, 20 Mar 2013 09:20:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the workqueues tree with Linus'
 tree
Message-Id: <20130320092003.34eef26c91419b4a2f0f3d32@canb.auug.org.au>
In-Reply-To: <20130319221308.GS3042@htj.dyndns.org>
References: <20130319131938.73dd0f1233c8aba41742aded@canb.auug.org.au>
	<20130319211233.GN3042@htj.dyndns.org>
	<20130320090540.81c687d28ffe3a6abe905816@canb.auug.org.au>
	<20130319221308.GS3042@htj.dyndns.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Mar_2013_09_20_03_+1100_0NZw8Ht_oilgrMrI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Mar_2013_09_20_03_+1100_0NZw8Ht_oilgrMrI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 19 Mar 2013 15:13:08 -0700 Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Mar 20, 2013 at 09:05:40AM +1100, Stephen Rothwell wrote:
> > > Anyways, I pulled master into wq/for-next and resolved it there, so it
> > > shouldn't cause you any more trouble.
> >=20
> > Ah, OK, thanks.   One small point, when you do a back merge like that,
> > you should always put an explanation in the commit message for the merg=
e.
>=20
> Oh, I do that for any permanent branches.  for-next branches are
> ephemeral (at least in my trees) so I usually don't bother.  I do
> compare against for-next when and after sending pull requests with
> proper conflict descriptions, so things are not likely to slip through
> there.  Hmmm.... if it's gonna be helpful to you, I'd be happy to
> describe merge conflicts and resolutions in for-next merges.  Would
> that be helpful?

No, that's OK.  I do wonder some times why some people have "ephemeral"
-next branches, though?  I guess, in your case, that you send your stuff
to Linus in more than one pull request and have just combined them to
reduce the conflicts for my benefit?  Which is fine.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Mar_2013_09_20_03_+1100_0NZw8Ht_oilgrMrI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSOSTAAoJEECxmPOUX5FEKpcQAI6khR0RZSQIfBitEJnZiHE9
qaUKChYSKkpi+q0qfmP8mAe4nmz3K+ugIWas8U8SmWMFSXLhR7h20R2zoqPtyGYd
gByc3Z9b8ki5BUgClM6hlQqygoG4mHavrD7J+sULRxY705tvYvO+PAnXWV8T+jvC
mhZXM8rTZqDbvbInn0xZqfACIlgH8vIlJaKQQtKGAhjOydgeaMPslaG+7/CVKspx
Iih3RdojqLJeHGB7QMgGkgsupMSTB+3kIUp7nC4fxSO92OplbRlIbTn8lvpNae0s
dUOyAuUhTX3T4IDam0adfK41PuwGJRDKrWEq2BLExx9H2al62fWBn3aKCftjb5SO
VpYhytpPCsNAO1aLB4RxW+OCVH0wcw7F3GBf0HtnCcHQNPnKQ5teRToD0MXEyWSd
4cPuJvU47Jl9GDY1XgxIVDWUAGdNX7rgIiyNBISELiGgHn2vNcg0SLX3t3UDaxXE
2t/jTf82W0CqPlEhDPwReg0omL9Ex0uC9CZ2g9nzNG0zbjYe0KlmbOQiUfkRy2Pq
68ctHOIXcXS/Dh+ar6F4jQIPwh3vWtFYVzUpzRhDAl9z1YNOmGfw36nGc3z66eZn
DL8/x3oAWr1t731pCRBzrkKNKMWwqHDArQazPWmaL6f7+8TqpSuuFCwtOZ0kfvhG
8l7NKwjvnHJGdYeHoF9G
=EQk2
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Mar_2013_09_20_03_+1100_0NZw8Ht_oilgrMrI--
