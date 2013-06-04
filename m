Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3FDHlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:41:19 -0400
Received: from ozlabs.org ([203.10.76.45]:34099 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759897Ab3FDHlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:41:16 -0400
Date: Tue, 4 Jun 2013 17:41:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 4
Message-Id: <20130604174107.99848a1dbb2532ceffe993eb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Jun_2013_17_41_07_+1000_JkD2i_Ko_4u4a3=j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jun_2013_17_41_07_+1000_JkD2i_Ko_4u4a3=j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130603:

The pci tree gained a conflict against Linus' tree.

The wireless-next tree gained conflicts against the net and net-next trees.

The staging tree gained a build failure so I disabled a driver.

The msm tree still has its build failure for which I applied a fix patch.

The akpm tree gained a conflict against the percpu tree that caused me to
drop several patches.

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

We are up to 227 trees (counting Linus' and 31 trees of patches pending
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

--Signature=_Tue__4_Jun_2013_17_41_07_+1000_JkD2i_Ko_4u4a3=j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrZoXAAoJEECxmPOUX5FE6dUP/jHPjPhrPqi2tTmgRuayY1jx
ikzn+Zq886zfjze4qsMB7eK3urwonfD3Yz+NfyALJmqkVKx+ohSy2b9g+1zSOkjJ
e3Aq3+xn8VlsnxG3+zseFjE6eXpjxeCfv64HIJ0hekeT21IcQTMssWpUqfW51Cts
8ju6wV2B+oPkFALRSaTxC2hUExgXDcq0ZJtIpe3z4wiQ9kchF45F+IyWtT59Hj4P
Obt21zna8DwAQ3+nWOasEL9S0GxJc7/LNwPKR/bhuntzVcl4aiMriUfO12gBY0nP
8nuAfOvGZ46HqHIpFAJZvhZxKngHzMCqzPXHigidVPTdKLSEaUwrT3b1hdC+++c+
Xxu+V7blNCGzelcJ8F4dUkx08fcr62DjDgUSP37vzLsBYGo32h8Ubnp75O0yhocF
XYDZj+AmficdM89vz6kI0SoKMDTRHiAwcYYaenhmnhApcYBYwtekIBf3jppiEZ4K
qH6iPZ9NTpEey/FPbfqegyNDPDsfR1IqS98ONtOUYxi67y9CHY+HwkbfoKCklpxP
UMNG+/p/CoISLBjna9zftkJyMa4oFeefKnHZxtfKfJcuOuulYd7mB3I1UylTFMKp
bwqrKWLMVFKlQNJlEw4WHnhG6nEAxWWDVIbJP3lxGJzz04FntpWGgYOF3Ct0o6q2
STtj4XA/uK8YHJBKjyu6
=dlxp
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jun_2013_17_41_07_+1000_JkD2i_Ko_4u4a3=j--
