Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3AWGnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:43:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55919 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3AWGni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:43:38 -0500
Date: Wed, 23 Jan 2013 17:43:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 23
Message-Id: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_17_43_36_+1100_6m.JmZVkV7eEzM1X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_17_43_36_+1100_6m.JmZVkV7eEzM1X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130122:

The powerpc tree still had a build failure.

The wireless-next tree gained conflicts against the net and linus' trees.

The sound-asoc tree gained a build failure so I used the version from
next-20130122.

The trivial tree gained conflicts against the mips and pm trees.

The leds tree gained a build failure do I used the version from
next-20130122.

The driver-core tree gained a conflict against Linus' tree.

The staging tree gained a conflict against the net-next tree.

The gpio-lw tree lost its build failure.

The pinctrl tree gained a conflict against the driver-core tree.

The tegra tree gained conflicts against the arm-soc and pm trees.

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
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 211 trees (counting Linus' and 28 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

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
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jan_2013_17_43_36_+1100_6m.JmZVkV7eEzM1X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/4aYAAoJEECxmPOUX5FE4PMP/1YAkXMSluwh+FPpeOP59ShB
nwDVfTCOYpU5VQIejvl2W8cWd4E8WMeqNjIRUZDZJQGv58cmRB8dAhTqvN0u3oVu
qJ09cF3nf9oFE0OWWAvjeN2wRbkCk3p4vU4BxhJtj2DJuhFDGqy6H8EPA2nOdm/Z
uDpSfMKp7gInGz/FFH6+n2CJFEA1hur6o4ltKSnRWXoheiUldtwOE/gA/PW8/Rlq
tYhD+fU7gGZtoboKSuuuik8JkcBpVyYYp1e36l7QjXhn2pU6MR3nsOcCYSwx9wDF
KA2donZgfCFX6sdQ6O3PoAeemIgV62La+cE6qVYXs560oIkb6Kk63YIDG6GE926p
M0+WryA4xk8kolwWcahnPzF1uzNN872i6yf3U6g2GWPiFHiS6YEeKpwgDmReozZ9
UAze1QhXsUc9ooXa/1ZZrP4h1tvbWxXeIc8fGU5W5FnmGTLzAld1L7eRgDYX14dO
I2JkVXiah4Vxy+KnNwsZgeiMc199gj/UtQoQphtdc56vSa8KOp0TPQtXSjfndzGf
DnAo+X5gcNLn+ahijKpN8Lm+Ou4mRCMg7p5nQWSy45s9wHD1tiACp/9Q4faU+/gW
yRSTn1DpT79chY4EitJG2pFc26uO+yR0nphvrTXr1Th5YTlB0thhpm4RO3xq4SGj
HhW311YCWGgCm2QYhPLc
=PTj5
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_17_43_36_+1100_6m.JmZVkV7eEzM1X--
