Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaJMUJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:09:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaJMUJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:09:39 -0400
Message-ID: <543C317E.5040408@nod.at>
Date: Mon, 13 Oct 2014 22:09:34 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        sahne@0x90.at
Subject: [GIT PULL] UML changes for v3.18-rc1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FrRlpxajtFTTNta1SKUPeU1sWGUkdDJbF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FrRlpxajtFTTNta1SKUPeU1sWGUkdDJbF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Linus,

The following changes since commit c798360cd1438090d51eeaa8e67985da11362e=
ba:

  Merge branch 'for-3.18' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/tj/percpu (2014-10-10 07:26:02 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to 5f786595a291092d20fafe10c5a30378971a8cc3:

  um: net: Eliminate NULL test after alloc_bootmem (2014-10-13 21:46:26 +=
0200)

----------------------------------------------------------------
Besides of fixes this contains also support for CONFIG_STACKTRACE
by Daniel Walter.
----------------------------------------------------------------

Daniel Walter (1):
      um: Add support for CONFIG_STACKTRACE

Himangi Saraogi (1):
      um: net: Eliminate NULL test after alloc_bootmem

Honggang Li (2):
      um: remove csum_partial_copy_generic_i386 to clean up exception tab=
le
      um: delete unnecessary bootmem struct page array

Thorsten Knabe (1):
      um: ubd: Fix for processes stuck in D state forever

 arch/um/Kconfig.common            |   3 +-
 arch/um/drivers/net_kern.c        |   4 -
 arch/um/drivers/ubd_kern.c        |   5 +-
 arch/um/include/asm/stacktrace.h  |  42 +++++++
 arch/um/include/shared/mem_user.h |   2 +-
 arch/um/kernel/Makefile           |   1 +
 arch/um/kernel/physmem.c          |  32 +----
 arch/um/kernel/stacktrace.c       |  80 +++++++++++++
 arch/um/kernel/sysrq.c            |  69 +++--------
 arch/um/kernel/um_arch.c          |   7 +-
 arch/x86/um/checksum_32.S         | 239 --------------------------------=
------
 11 files changed, 153 insertions(+), 331 deletions(-)
 create mode 100644 arch/um/include/asm/stacktrace.h
 create mode 100644 arch/um/kernel/stacktrace.c

Thanks,
//richard


--FrRlpxajtFTTNta1SKUPeU1sWGUkdDJbF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUPDF+AAoJEPmeIjfg4UaaJSsP/1K/Edz5daMkgES6JXiqyoEh
GGRupgL2rAbrWjE8AsC95DQFH7vm+sTg/CHGvdZfUNI6dO5DUHX2xosM2Dw4qE/0
phmMfo5FUgLZqRBIxt+a9QdvwPQttNamI8E31BWebNXTTHPx4OorrrUp+O+YZ+4q
evyaFMCl3QD+uP474foaBsP4dZEIJpszxQrRXDtNpIZSOdZM5Ocdvk0zefeaZMMI
DjxVcmDbTkaEk3w6Sz4AT8C9IkmYVj5P23726f8C9GG4bQGlJpRyTrBTHNoYKPXN
l/IqVVQpzY7MoQ+LyHKoVJFLX9ZweXy6vbQ8nxKITY2vGd6GfTfWFNQti5KGZFvY
Zyfj6o9FJnrG+Z3ph4EX00fSWzvWxIuKm6b1om+P0iThdue0/pYEP7IIYKxC+Y5/
/0BhKPc1kXYyjz/DOIHvCRoc/B4hGKOPiWPvkPvXopurC+i6Qgw6MCUzTwV/h9Eh
RT4rb5kcHQvXTFl6PtFFxlYCFTs0GP6kVM/Z77noVs6KnqS+9OEM/cX+bxq1UKD9
j/Du1M6hUcY7pS8k2IQsuaJY16V+jHA4tVaA9hlFryGCKfwJQbOztcNi7vXep7oy
lmLvO/DksUDRLsdx1YISEEcAnr9+duVbrm/hUh0UinfHn0C5j3+Ketbms10RTXv1
Q5qVKR8W8WqwSlu7hzNV
=2VCw
-----END PGP SIGNATURE-----

--FrRlpxajtFTTNta1SKUPeU1sWGUkdDJbF--
