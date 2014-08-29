Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaH2Nnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:43:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37963 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaH2Nnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:43:39 -0400
Message-ID: <54008387.9090003@ti.com>
Date: Fri, 29 Aug 2014 16:43:35 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.17
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bgtt6OwgDjeTQ8UU8JXP7HgOQfcbfkfRA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bgtt6OwgDjeTQ8UU8JXP7HgOQfcbfkfRA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980c=
ef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.17

for you to fetch changes up to 4d4e2c003bd6c6bdd85080bd096d54d5d251defa:

  video: da8xx-fb: preserve display width when changing HSYNC (2014-08-26=
 15:36:51 +0300)

----------------------------------------------------------------
fbdev fixes for 3.17

Minor fbdev fixes for da8xx-fb, atmel_lcdfb, arm clcd and chipsfb.

----------------------------------------------------------------
Dan Carpenter (1):
      video: of: display_timing: double free on error

Ian Abbott (1):
      video: da8xx-fb: preserve display width when changing HSYNC

Jon Medhurst (Tixy) (1):
      video: ARM CLCD: Fix calculation of bits-per-pixel

Julia Lawall (1):
      drivers: video: fbdev: atmel_lcdfb.c: fix error return code

Pranith Kumar (1):
      fbdev: Remove __init from chips_hw_init() to fix build failure

 drivers/video/fbdev/amba-clcd.c   | 23 ++++++++++++++++++-----
 drivers/video/fbdev/atmel_lcdfb.c |  2 ++
 drivers/video/fbdev/chipsfb.c     |  2 +-
 drivers/video/fbdev/da8xx-fb.c    |  2 +-
 drivers/video/of_display_timing.c |  1 +
 5 files changed, 23 insertions(+), 7 deletions(-)


--bgtt6OwgDjeTQ8UU8JXP7HgOQfcbfkfRA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUAIOHAAoJEPo9qoy8lh71f2sQALHoGmRiwIeJix1a8gCIJ599
iha90gb9tV8AN0/+4U4BbUHt1PIGaUYR9okVrhyGjShDeX3cN89BLcgWg1AaiiC4
Ks6V53sKjoa1ZOhjy21GQjxqfKS7ubnnciXHa/QNBzuqZowy7tRKU4LlP24mysV9
o2K13DPrLAwUmeHGsRlNzWRXPkkQz4YArWHzwNJnAaBo4w8VduAzGVHc23qZI7Lu
jg7JiowR611Uh9iRcVYKfI9BiPo/bklDKX0KaZd9qcC+u+MDAmNu+ZkPQvOC05Po
5T/oTdGgVTGfmq9kXo1Uplf0JyC2Nt+rg0K11cZ0T9cx9HFULp3pQ9IztOt9PgTs
Z9AJqk9goHZaZNMr1r0hRkHZcR8l5e482nU6wH3o7hxmI2Tx17ikdK2nG2GHe+x1
AoJus4Np34JF38LMO7GfQaPEiWdWsW5m4mxtsp91JYCeQLi0lDDEzKrmDJw1pGWU
cYIrAwLyZyFI/N5ffXoLRXCCSCX9HKH2IOxtsSA2609gm15W6RSKOs0HZiIFEMTI
Lka5E/2wxXguTvE02xy2SjghXQ4emh0LmPl7jF1U+6jmOKzQpwRvkwd6j1YBooA+
8VEkMxN5vbAacfq3m9VsV3YmWDmt+1KPtzSmPDD06TEzV30MxqAHxt/rlvQ3QQSw
8Sp3MgrX2XNHkV3xCWV/
=FO9l
-----END PGP SIGNATURE-----

--bgtt6OwgDjeTQ8UU8JXP7HgOQfcbfkfRA--
