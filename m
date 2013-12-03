Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3LCDMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:12:07 -0500
Received: from ozlabs.org ([203.10.76.45]:39367 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab3LCDMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:12:03 -0500
Date: Tue, 3 Dec 2013 14:11:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 3
Message-Id: <20131203141155.f15a7389181f7ea1a619069e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Dec_2013_14_11_55_+1100_d5kazQSpJ.HhRgy0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Dec_2013_14_11_55_+1100_d5kazQSpJ.HhRgy0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131202:

The wireless-next tree gained conflicts against the wireless tree.

The sound-asoc tree gained a conflict against the slave-dma tree.

The akpm-current tree gained a conflict against Linus' tree.

Non-merge commits (relative to Linus' tree): 2063
 2264 files changed, 88552 insertions(+), 61433 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES - this fails its final
link) and i386, sparc, sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

I am currently merging 210 trees (counting Linus' and 29 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Dec_2013_14_11_55_+1100_d5kazQSpJ.HhRgy0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSnUv/AAoJEMDTa8Ir7ZwV4MQQAJRNS6jHWwtWV/iy8SqIc+pQ
sbe8MnwGeQsM4g618JUUUmNgBz8nFLhzjt1oFHsx6hZlEXhq1TwjXRkS/b/K1uvB
dfgl4yodJdA0auYnHKjtioe+hrwc12agQWS5IQEeUA4Htb6hrSabedYt5ufF8j8t
OJB3dEF6UmWdPCJ2jokL1j+ufyr0rW2oOLt3v4Vb/Dmh7FqGxkNo9cGRF6PMTsGy
Z0B5Jd/BVmtkHxqMwxD8KL6o9Xjk3stg/ES6nuzrxgHkfEJQrp8y8NwhyPzLIbJT
3oXEXbgmvSIGsePtlVd0a+zksTGnxzMSyxQrY0LKzIDwV4pfYMnXhQslGO3h3WLc
I7E1iFE+OEd0I6dFbpsMfSOJSye4VmGAaetSJvGOU0G40zTtXk6kjEn/6OQ+Nw9S
sJqJvuw/QaJ7Aqk1v2Cze3bkUBH97SUMxHnwlXdnfTy3yqZEYZ5YDwbc/kOyKDF8
hNAlwBidx69veYM5j1indoucldVI/OtNn7nP7UgemcGcxe1REJFjx35zFnfYiSrh
6Yqe+I7GeqwI6YGszSl+gIzzzwnMb+EskKxHK5tq0B5jTg5WWDcHzGF22k3xSSkc
DJmiRzhKOWmQ7GTLYSv1pJ1wH3PSsHLzhwwFwESyY4tCBC1mrqXDliXm98fP1zec
KSbH249pc7GpdY6MG4zN
=r1N3
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Dec_2013_14_11_55_+1100_d5kazQSpJ.HhRgy0--
