Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaKJQZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:25:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42976 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaKJQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:25:31 -0500
Date: Mon, 10 Nov 2014 17:25:23 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] asm-generic/io.h overhaul
Message-ID: <20141110162520.GA3926@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arnd,

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  https://github.com/thierryreding/linux.git asm-generic-io

for you to fetch changes up to 09a5723983e383e7d627fe3191366761722695bc:

  arm64: Use include/asm-generic/io.h (2014-11-10 15:59:23 +0100)

Thanks,
Thierry

----------------------------------------------------------------
Arnd Bergmann (1):
      ARM: ixp4xx: Fix build with IXP4XX_INDIRECT_PCI

Thierry Reding (9):
      ARC: Remove redundant PCI_IOBASE declaration
      ARM: ebsa110: Properly override I/O accessors
      ARM: ixp4xx: Properly override I/O accessors
      Change xlate_dev_{kmem,mem}_ptr() prototypes
      /dev/mem: Use more consistent data types
      asm-generic/io.h: Reconcile I/O accessor overrides
      asm-generic/io.h: Implement generic {read,write}s*()
      ARM: Use include/asm-generic/io.h
      arm64: Use include/asm-generic/io.h

 arch/arc/include/asm/io.h               |   2 -
 arch/arm/include/asm/io.h               |  89 ++++++--------
 arch/arm/include/asm/memory.h           |   4 +
 arch/arm/mach-ebsa110/include/mach/io.h |  25 ++--
 arch/arm/mach-ebsa110/io.c              |  14 +--
 arch/arm/mach-ixp4xx/common.c           |   2 +-
 arch/arm/mach-ixp4xx/include/mach/io.h  |  28 ++++-
 arch/arm64/Kconfig                      |   1 -
 arch/arm64/include/asm/io.h             | 122 ++++---------------
 arch/arm64/include/asm/memory.h         |   2 +
 arch/ia64/include/asm/uaccess.h         |  16 +--
 arch/s390/include/asm/io.h              |   5 +-
 arch/s390/mm/maccess.c                  |   4 +-
 arch/x86/include/asm/io.h               |   4 +-
 arch/x86/mm/ioremap.c                   |   4 +-
 drivers/char/mem.c                      |  13 +-
 include/asm-generic/io.h                | 716 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 17 files changed, 730 insertions(+), 321 deletions(-)

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUYObwAAoJEN0jrNd/PrOhb/sQAI95hW/ByOGJe26pj0/Z9BbN
9SWSZfl0l50AcwxKWgOrwVosyuXXsnqno3nrBuHjMfgb3HoB05FGCVCrxPHrAvWd
O6clM0xorPKgzgghR/Q5qZnXUzxJZAqLA13loEqmPHJlIMnxOB+OLz6UIKjT/det
aILw/5iqgdNTMISTC6mfUTGCao69S5wJgcO02U+zVznzSP6IzkDK3UIn7WMrjISQ
dDBHd/FgA3EpyvKnoeYXb5YKh9PGmMNJL1UTmnRVMzY2RGDOcaaoBnQLv5O4l08Q
PhzkltQpZe8tWpUGKozOaCBtgeGsNCyQsWtbCeSwVdcOVREdjgagOB8MEPazSGsu
rQ3KkR9N201ztxEO9E2vo5GgZIETp/viYzGXgZESnEIw/07OIoXHb5AU/s6YCZCX
ZXk49A2zpOn418oZdkuBXr7yan9izAPVte1AvA+2yMsxVOyg+TmEiDE2tcThOfoe
z8ERe5QjH+Kr7+SH4IFVDZKgAjgVTGIUS0zCiLgsqAX/oWoMLJbI/E0B/HDoKb33
AHkHFOwq40zU66pUvjctMR86D7mctHFYmzBnhYC1YJRodWaoIjGqtpbohvgiHTu4
L84eaBUtpadhCThVGNFEs7yMpEoY45wFQXlewLvb4XSncfMGD+fgDQRRqK3h6Kxx
NA1TdgTMgUI4ftYz5rDG
=99DO
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
