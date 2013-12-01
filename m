Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3LAMO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:14:58 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751247Ab3LAMO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:14:57 -0500
From: Richard Weinberger <richard@nod.at>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] UML fixes for 3.13-rc3
Date: Sun, 01 Dec 2013 13:14:32 +0100
Message-ID: <3994463.tIZbdZ5tnp@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6199045.vrAS1g4IA8"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6199045.vrAS1g4IA8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Linus,

The following changes since commit af91706d5ddecb4a9858cca9e90d463037cfd498:

  ima: store address of template_fmt_copy in a pointer before calling strsep 
(2013-11-30 13:09:53 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to fff6540cbcb56a6ae92d4fd4b0864c8d13a8f932:

  um: Build always with -mcmodel=large on 64bit (2013-12-01 13:06:51 +0100)

----------------------------------------------------------------
Fixes two regressions which got introduced while the merge window.

----------------------------------------------------------------
Richard Weinberger (2):
      um: Rename print_stack_trace to do_stack_trace
      um: Build always with -mcmodel=large on 64bit

 arch/um/Makefile       | 9 ++++-----
 arch/um/kernel/sysrq.c | 4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

--nextPart6199045.vrAS1g4IA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABAgAGBQJSmygxAAoJEPmeIjfg4UaaS04P/1gkKzTSlLGbV/Yhr4bdGCj1
2mm+18x3U2VYITk6+hYwqVKtBSD4t734SK3vM6lDkeoHrXExp1IMBvoYl1rRHxYX
Fyaog1z9ssK2uIA1Xt4GhEZRGOxGk8Smedj/YSfToTo9WwthUfsVW1wwmOAtFSn6
M/jecyTJclPid6Nsb53OQP9o1H5+1hx8nfqOme0PscOcgEFqqph64HzhWXnUsoor
NfYMTl0sNOXQypCNpRivcLHdb+oekIzTKBCNO4l94F6Sa9n5wa71YEIJGVgtQF3M
Al/+O2W0bF1G+nHlXD4qR3JAGPWuocfWiCql6yqTvJJQKyjhrOhMBQ0fWdI6zVXq
NXVRHEH5sOfTg16XSxwuMAhqVQ+BBpN2B1jtDsE4bnRBODqm5pXHJ55/BmJ0hY30
IzfhaV27WDbA9LhOtmgxmYJTgQx0fhDbV6xNtD2T807P4sG9sstCzJCQ2ek23W9V
f6AvflfsfVbPr5BJfWTaSYQvjnufYFrgbLevWP6bYGoP4/TzbPvapl3w6BGrVObh
fLhbPSnxtwKFV8IZNNSerFqui9/51XBD0dNGf7hL1WZu5rBVJ43exvn1DnB7BQPE
p4WjJzuRLl9sn1y5HIA0S4v8K++Jab6GqG2D0F/LJCJVNue7kcFWgB0v8QE2X8lw
d3VuromAsTTtPdS+57bj
=rk8T
-----END PGP SIGNATURE-----

--nextPart6199045.vrAS1g4IA8--

