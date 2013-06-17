Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3FQIvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:51:15 -0400
Received: from ozlabs.org ([203.10.76.45]:54358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3FQIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:51:13 -0400
Date: Mon, 17 Jun 2013 18:51:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 17
Message-Id: <20130617185106.5950ffbf4b96acd9b2b2c834@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_18_51_06_+1000_C166In6A1uc7+dFa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_18_51_06_+1000_C166In6A1uc7+dFa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130607:

New trees: arm-mpidr and arm64-hugepages

The arm64 tree gained a conflict against Linus' tree.

The pci tree gained a conflict against Linus' tree.

The net-next tree gained conflicts against Linus' tree.

The drm tree gained a conflict against Linus' tree.

The drm-intel tree gained conflicts against Linus' tree.

The sound-asoc tree gained a build failure, so I used the version from
next-20130607.

The fbdev tree gained a conflict against the drm tree.

The leds tree gained a build failure, so I used the version from
next-20130607.

The driver-core tree gained a conflict against the devicetree tree.

The pinctrl tree gained a conflict against Linus' tree.

The arm-soc tree gained conflicts against the net-next and tty trees.

The msm tree lost its build failure but gained a conflict against the
arm-soc tree.

The renesas tree gained conflicts against the sh and tty trees.

The clk tree gained a conflict against the arm-soc tree.

The arm64-hugepages tree gained conflicts against the arm64 tree.

The akpm tree still had its build failure for which I disabled some
staging tree code.  It also some patches that turned up elsewhere and
gained a conflict against the kvm tree.

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

We are up to 229 trees (counting Linus' and 31 trees of patches pending
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
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Mon__17_Jun_2013_18_51_06_+1000_C166In6A1uc7+dFa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvs3+AAoJEECxmPOUX5FEHqsQAJMxS1V7rtryQROEtVRWyZqg
tFAdUEPfuJsna8k4pNDSHdOu2/j0umqh5ZgoS4fGLdrwz+Z1VCWbewiX5D0plZDR
BWovv96UIo7dfr1DBf+6M94Hb3oI6G0ToIhh0A7khpRYewI+qD46tYLWuA6mLSDE
6xZiOZ8ZFd2EYXZqv7RTTLbF/rYEsOZ6qnFmKF2F7gkDN0bbW446OumOKQAIgtWc
yiaPriunkK3M26s3BqIzkXOuc1VGkNVtLpiYxg3h6l3kKrt/lRPfQ1z1tMrs7ici
syVMluOhDlVPXE5qzuwIbiCFOCncTRPunEOcdsXPo56AkjHU/zlGP98xEZLdGo3O
6P9dTxL0junbVGFm2XK8wJjcOcPu4UoCH5djP6q3lGms6nTijNwxU/+PmjHhypSW
Dkd+IcjARnkT6AaoyFCH/M2uvTGv02BCSZJduFHFklix5hh0pAho+do11ze0InAg
pbTIupiMAsfOJwqOuq4nme3Z1WZBrdyaBPHj6sAtcoyo0XF1XKWUiVzil6AHO8nU
aW/WXfDM18EVHFq5zpBs2mGC5BbhwjfPcruyo/5A5spwfhA7c4+Nkah/MTiz47dv
hgEZ35B8AdQ18QleY44KTvN+mNlIi8lWy8PQP4/xuAieSINiPjyn2v+D3X1beskX
Ajzr92ozl9PLO8UVs8zh
=+ssK
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_18_51_06_+1000_C166In6A1uc7+dFa--
