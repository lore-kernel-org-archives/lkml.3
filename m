Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3I0JHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:07:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3I0JHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:07:41 -0400
Message-ID: <52454AD9.3050502@ti.com>
Date: Fri, 27 Sep 2013 12:07:37 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] fbdev fixes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="CsoIddlkjkTFErhc88I6jRmuBkVjIQBf1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CsoIddlkjkTFErhc88I6jRmuBkVjIQBf1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb7=
3f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.12

for you to fetch changes up to 6d0bb818041a02be682abadb3ba35ff608f7d60a:

  video: mxsfb: Add missing break (2013-09-26 15:33:23 +0300)

----------------------------------------------------------------
Small fbdev fixes for various fb drivers

----------------------------------------------------------------
Andrzej Hajda (1):
      video: of: display_timing: correct display-timings node finding

Marek Vasut (1):
      video: mxsfb: Add missing break

Mark Brown (1):
      OMAPDSS: Add missing dependency on backlight for DSI-CM panel drier=


Sathya Prakash M R (1):
      OMAPDSS: Return right error during connector probe

Tomi Valkeinen (1):
      OMAPDSS: DISPC: set irq_safe for runtime PM

Uwe Kleine-K=F6nig (1):
      video: mmp: drop needless devm cleanup

Wei Yongjun (2):
      s3fb: fix error return code in s3_pci_probe()
      neofb: fix error return code in neofb_probe()

 drivers/video/mmp/hw/mmp_ctrl.c                        | 17 ++----------=
-----
 drivers/video/mxsfb.c                                  |  1 +
 drivers/video/neofb.c                                  |  4 +++-
 drivers/video/of_display_timing.c                      |  6 +++---
 drivers/video/omap2/displays-new/Kconfig               |  1 +
 drivers/video/omap2/displays-new/connector-analog-tv.c |  2 +-
 drivers/video/omap2/displays-new/connector-dvi.c       |  2 +-
 drivers/video/omap2/displays-new/connector-hdmi.c      |  2 +-
 drivers/video/omap2/dss/dispc.c                        |  1 +
 drivers/video/s3fb.c                                   |  9 +--------
 10 files changed, 15 insertions(+), 30 deletions(-)


--CsoIddlkjkTFErhc88I6jRmuBkVjIQBf1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRUrZAAoJEPo9qoy8lh716jcQAJ0eiMtQUED5C3xfONDvsEND
R9C5Geu7xEgyoFlsrfweNm0iBGILbnrddc/PXXr65MBr7osxN5EEDJMsiVMCYl/Z
TlKYjOf5adQAcpVepCg2MOBG5yR+sySEvGu4WgXzViikwBr9oYuFZVOMqp/BeOxU
BUDl3e0K8wkgcgykhdCa5iH9/QcZJA0hHeZRKdRpABZ5aY1SkG4MAHdoFAU4ibNg
8lKjt832wQJHQsrV+dj27yKYb74p1N/CO19JQjSvyORUT72fkFWVnpXXXiCyFiR9
VT2FJf782v7pZioRd8pCj1vBRI8g7ApYMid2A4UPkfvLr0aSW60shodQV8EnfFhF
6Z2jNFrUXBh88qM5jp1lv6ypUHQ3XNk31cUCiKU47y418hBK/DxPUHC46BEhAR4y
o5P1+GWGBvBnh9jyYGhvFG1HakAAVfeM3MzMvxb6Fa71PmticdWT5/jvnDxKE2aW
GEswK21YkLQZmpfRkHasd4QYpapHwOOkdCTNlJz6hBO/7KZePm7BbwNv8VSR7OhK
caGDB8ZIC7msUQjPH3tqtlCLHUPK798a337VUD37IM/ywAezZ5m98p2XBT8Gv7GN
Q9bMPIdezYFav6RgcqwNdfZ24F4KhcjuD6oWt0/QRfdWkZt9PeDjwoKUBWmmBoZ6
Th9NR2qVvmri6NKg59Jl
=LS+K
-----END PGP SIGNATURE-----

--CsoIddlkjkTFErhc88I6jRmuBkVjIQBf1--
