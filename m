Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbbAOLXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:23:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48733 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbbAOLXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:23:05 -0500
Message-ID: <54B7A315.4030104@ti.com>
Date: Thu, 15 Jan 2015 13:23:01 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.19
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="3LFwKP5277brCdPLa0X1LBC1DMaILVvmX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3LFwKP5277brCdPLa0X1LBC1DMaILVvmX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull fbdev fixes for 3.19:

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d1861=
15:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.19

for you to fetch changes up to ef6899cdc8608e2f018e590683f04bb04a069704:

  fbdev/broadsheetfb: fix memory leak (2015-01-13 15:13:45 +0200)

----------------------------------------------------------------
fbdev fixes for 3.19

* broadsheetfb: fix memory leak
* simplefb: fix build failure on sparc

----------------------------------------------------------------
Colin Ian King (1):
      fbdev/broadsheetfb: fix memory leak

Hans de Goede (1):
      simplefb: Fix build failure on Sparc

 drivers/video/fbdev/broadsheetfb.c | 8 +++++---
 drivers/video/fbdev/simplefb.c     | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)



--3LFwKP5277brCdPLa0X1LBC1DMaILVvmX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUt6MVAAoJEPo9qoy8lh71XXUP/ijC5Jq4X4t4boEBi79AFqgL
5aVQYpvDqVWdoUqwOV17Ui2JHdZtU69Y5zVWg3NUCMcTZ3hD13coDWczf6MbB69O
ku4wSFKbLM3ovUxPnVRKVThV89Cmk9lCxVP9Bbw1lObKPBlCPT+hKH56RvV8xKBU
oR3z8HOvOV3Tc2bVgZp3K/Ob7ztmHtFsLVtACEy2aSC+5MiYHlWtEbuEmQBpfWl6
ilpAZ7sQpw9lh4A0UV1MUzOYMtgbem3z5i82ahMQHxox+gdnZERyL/DAxUarylGj
/saOtZJh+bF+VVRw+c08rfqabHIT6qc9xF+ZVCdRBLTxI/ckCoaBEKQ6bu/JtNIV
UkGtFUUkKOsFv/6ZlZimtormA8x3YApIgaDWf6ETY2XYvS5e7n+XNUui9NivcT8v
zOPyPCAeJB/rUC3a9QUw04NtnHW6YAZXrE/QBNksdWRWNDSr/ddwayUe1xzyyQIK
jpmwp2YzbfmKqVvh0hzoa0L5O3kxWvzIaKbs0cammtlnZu5hCdt/zhT6Sd0eK1A3
RtpZtRQBodb7a77m/tM1Bhh4s3PrGKTSChj2p2uk4OzwFlkyFM915ry6nmf9POBj
OXxqBFmsmAxsRzjQ3e7494dnnXiPE5niBGl91AbPF4GVTL/3mVm4vEk9PvXWnbQA
jDyhwYHiaeCw+Az5KEWL
=uZSB
-----END PGP SIGNATURE-----

--3LFwKP5277brCdPLa0X1LBC1DMaILVvmX--
