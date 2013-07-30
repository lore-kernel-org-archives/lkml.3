Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3G3Gbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:31:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58474 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3G3Gb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:31:29 -0400
Message-ID: <51F75DBC.2060006@ti.com>
Date: Tue, 30 Jul 2013 09:31:24 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] Small fbdev fixes for 3.11-rc
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="slEX1Wfd59eSJkkLBSfHeTHmDhFhdQV6L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--slEX1Wfd59eSJkkLBSfHeTHmDhFhdQV6L
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a=
4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.11-rc2

for you to fetch changes up to 7808e3291e1e101e9ad6e8263119c4a2abae05ef:

  video: sh7760fb: fix to pass correct device identity to free_irq() (201=
3-07-29 11:25:03 +0300)

----------------------------------------------------------------
Small fbdev fixes

- Compile fixes
- atyfb initialization fix
- Fix freeing of the irq in sh7760fb & nuc900fb

----------------------------------------------------------------
Dan Carpenter (1):
      fbdev/atyfb: fix recent breakage in correct_chipset()

Luis Henriques (1):
      vga16fb: Remove unused variable

Michal Simek (1):
      video: xilinxfb: Fix compilation warning

Tomi Valkeinen (1):
      fbdev/sgivwfb: fix compilation error in sgivwfb_mmap()

Wei Yongjun (2):
      video: nuc900fb: fix to pass correct device identity to request_irq=
()
      video: sh7760fb: fix to pass correct device identity to free_irq()

 drivers/video/aty/atyfb_base.c | 4 ++--
 drivers/video/nuc900fb.c       | 3 +--
 drivers/video/sgivwfb.c        | 2 +-
 drivers/video/sh7760fb.c       | 2 +-
 drivers/video/vga16fb.c        | 1 -
 drivers/video/xilinxfb.c       | 4 ++--
 6 files changed, 7 insertions(+), 9 deletions(-)


--slEX1Wfd59eSJkkLBSfHeTHmDhFhdQV6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR9128AAoJEPo9qoy8lh713t0QALBz7htdpyDp9GE7qmNaiGXW
d4WLXB1wbOZwkcIZ+vbPv7cDEGHo7xKyukAfs2I16NiezNKo8qFi6UFnvCXU/3hw
ly/rfZ6+H+NURfs1okGopTb/rsAQRvg9ax+OxxqCQuZLbJYmufxj8uVNU8qeDq52
8qIasREROBoRa95neKO0M2I4Fl9Zwu3PuHILpzpwvh3vSwhQNhU1XejanYluhedl
FW1qwGynAx/ehEJNTNDqmI0AGptXm4WRIRZlv+bUGZ69LWaawocdgHQKXEYaVAFz
ORc3sUtrc205CyCQqlwcF55AhAllgqkzaOk5V4TjSCKfZGsVsUEcVsqfUyPqSiwz
w9yK64Lm5xFH5FOX6MgMuHC9OIcq6UWY70doJUBDiL3Aa7neNZt5ZTSxO8vE6+8y
oKrLsDzJTUNd6grgMOQm1wBIvnjrizx/nOkSbzrM5AKCF9t7nii9cq9UK9MGY1IF
aW0h1WVsIYXTWOtviIzWg7l2Z2tKS6kATM/8qvq4X5E0on1MF/VgYofxPzn6036o
rFedvc9CycnGt5iwUWgq6tm5arGU0JOVc7C1hSg7KA8kJJtyl+vxgDDV2vxqWqh2
MEd+J4Foi9KlpdZsw9LP4gcIKD9A88uEVcfuK9VuikzWc/PQW68H8hM+ibWkEh63
luqZo5gmzrOZDtbSJNCB
=IG3U
-----END PGP SIGNATURE-----

--slEX1Wfd59eSJkkLBSfHeTHmDhFhdQV6L--
