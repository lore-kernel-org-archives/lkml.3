Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBLKry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:47:54 -0500
Received: from ozlabs.org ([203.10.76.45]:55597 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaBLKrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:47:51 -0500
Date: Wed, 12 Feb 2014 21:47:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-Id: <20140212214743.22fd2d8e1889ae69986e58aa@canb.auug.org.au>
In-Reply-To: <20140212063933.GB7984@mtj.dyndns.org>
References: <20140212162500.242e91e4cc3541b992fa3a0c@canb.auug.org.au>
	<20140212063933.GB7984@mtj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Feb_2014_21_47_43_+1100_RwAAQvuBnZ4/qlbp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Feb_2014_21_47_43_+1100_RwAAQvuBnZ4/qlbp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, Tejun,

On Wed, 12 Feb 2014 01:39:33 -0500 Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Feb 12, 2014 at 04:25:00PM +1100, Stephen Rothwell wrote:
> > Presumably caused by commit 2bd59d48ebfb ("cgroup: convert to kernfs")
> > (see the comment in commit 1ff6bbfd13ca ("arm, pm, vmpressure: add
> > missing slab.h includes")).  I wonder how mane more builds are broken by
> > this :-(
>=20
> Dang, I was feeling pretty safe as kbuild bot was reporting build
> successes.  We better fix them at any rate.  David / Sam, can you
> please pick this one up?

It really needs to go into the tree with the cgroup commit so it doesn't
break there.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Feb_2014_21_47_43_+1100_RwAAQvuBnZ4/qlbp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+1FVAAoJEMDTa8Ir7ZwVI+8P/0ileBxxuZkdwk1WGBWfpP57
VSGoZA/XII1zyaONIaUle0xEgny7QUqgvGE3hlqWfq/aTHjQB2ADOHyEPO1QmJGK
gEKP3znBXkAwDXamFjlO0+TeEvNcWl8QiUAwLL0u/lTDLTrNqc7xPrS3pUpZ4j2/
YGzH+7zBt24nMfOCxAXqXJN7XccD1xP0Ex/x+lhqImVl4A/lZxOrQrWey0hly73P
4KRguPWFwwwJwZPsXR3PaIzVrPiLZ6VliLQcsC6YDnYs6N5hbyg4ykOlU0p6H7nc
w8Ay2JAJ/wzubMyBOU2B6OIF4dATOBvwSEz9UKYXkk223fiqah+XH2YmRz8hSNcW
5S0HY8BsPhGzS1LXDi8qTV625JqSiHJ6TpuPAwdkMPDhi7bowvkWvLGHNoENqF4C
lmHls94zURPV5HJmS3KOAah1zzQEVW1YDTqIj8pwoQwIRGzTrH+7PJup9h1/dgG/
zXQjFZxZN0P42rZyHNGrPolRPAepA4FzOQdFuY6bxRLdgcx9F5zevGWDml5YL4ZI
RCi+LrkEETYjKX953jTzMggLvjTyYQ4LjgLNnDklHNpEHHKl9KPm4L6C9RatWDTN
uPC0Ogi2EXyANQASoBQr0qVrNPeRuAP9HWDa3ZZwfCF6rMctk4mBoiU3zmi5700P
nzfXwR/aSDTlYnJ+4vKA
=iglP
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Feb_2014_21_47_43_+1100_RwAAQvuBnZ4/qlbp--
