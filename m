Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaJ0VBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:01:54 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:18443 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaJ0VBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:01:52 -0400
X-AuditID: cbfec373-b7f236d000000948-de-544eb2beef59
Date: Mon, 27 Oct 2014 19:01:45 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.18-rc2] media fixes
Message-id: <20141027190145.565b9ebf.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e9woO6+TX4hBrummVjMWb+GzeLCqQYm
	i8u75rBZPOp7y+7A4nFixm8Wj8+b5AKYorhsUlJzMstSi/TtErgyPn3cwFzQoVBx5ORB9gbG
	JskuRk4OCQETif2tbWwQtpjEhXvrgWwuDiGBJYwSv+bPZoFwGpgk7l9YAFbFIqAq0dtxkx3E
	ZhMwknjV2MIKYosA2Z9fXGEFaWAWWMQoceBUMxNIQlhAV6Ll0mxGEJtXwEri07MmIJsDaJ2z
	xPzP2RBhQYkfk++xgNjMAloSm7c1sULY8hKb17xlnsDINwtJ2SwkZbOQlC1gZF7FKFpanFxQ
	nJSea6RXnJhbXJqXrpecn7uJERJ6xTsYX2ywOsQowMGoxMP7cKdviBBrYllxZe4hRgkOZiUR
	3gNpfiFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGIOO5/Q6eLGnJO/VtxVOl113WcIvoy3JwezV
	toVpPAw2guphq1xYbNOMdWo4PvDx3P399GLS4QsHFzSZ1E5KTdK4tiIrsUB849n5RX9/q/7y
	kFneWeHr+tW2NntTy6kfSQ/+XD3be3jCpWD2RP3JXHK7JrGeZVL5Hv/Z+Zd6d7OQe0tD87sJ
	SizFGYmGWsxFxYkACQUfFBsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc2


For a series of driver fixes:
	- a few compilation fixes with randconfigs;
	- one potential compilation breakage on userspace due to the usage of
	  a gcc extension;
	- several warnings fixed;
	- some other random driver fixes.

Thanks!
Mauro

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc2

for you to fetch changes up to f3d83a101266ffa0bcb0744a0d33de823a584845:

  [media] s5p-jpeg: Avoid -Wuninitialized warning in s5p_jpeg_parse_hdr (2014-10-24 09:36:59 -0200)

----------------------------------------------------------------
media fixes for v3.18-rc2

----------------------------------------------------------------
Dan Carpenter (4):
      [media] hackrf: harmless off by one in debug code
      [media] em28xx-input: NULL dereference on error
      [media] xc5000: use after free in release()
      [media] usbvision-video: two use after frees

Fabian Frederick (1):
      [media] tw68: remove deprecated IRQF_DISABLED

Fancy Fang (1):
      [media] videobuf-dma-contig: set vm_pgoff to be zero to pass the sanity check in vm_iomap_memory()

Hans Verkuil (5):
      [media] vivid: fix Kconfig FB dependency
      [media] em28xx: fix uninitialized variable warning
      [media] vivid: fix buffer overrun
      [media] wl128x: fix fmdbg compiler warning
      [media] tw68: remove bogus I2C_ALGOBIT dependency

Jacek Anaszewski (1):
      [media] s5p-jpeg: Avoid -Wuninitialized warning in s5p_jpeg_parse_hdr

Kees Cook (2):
      [media] af9035: make sure loading modules is const
      [media] anysee: make sure loading modules is const

Laurent Pinchart (1):
      [media] v4l: uvcvideo: Fix buffer completion size check

Lubomir Rintel (1):
      [media] saa7146: Create a device name before it's used

Mauro Carvalho Chehab (2):
      Merge tag 'v3.18-rc1' into v4l_for_linus
      Revert "[media] v4l2-dv-timings: fix a sparse warning"

Olli Salonen (1):
      [media] cx23885: initialize config structs for T9580

Sylwester Nawrocki (1):
      [media] Remove references to non-existent PLAT_S5P symbol

Thierry Reding (2):
      [media] s5p-jpeg: Only build suspend/resume for PM
      [media] s5p-fimc: Only build suspend/resume for PM

Vincent Palatin (1):
      [media] v4l: DocBook: fix media build error

 Documentation/DocBook/media/v4l/compat.xml    | 4 ++++
 drivers/media/common/saa7146/saa7146_core.c   | 6 +++---
 drivers/media/pci/cx23885/cx23885-dvb.c       | 3 +++
 drivers/media/pci/tw68/Kconfig                | 1 -
 drivers/media/pci/tw68/tw68-core.c            | 2 +-
 drivers/media/platform/Kconfig                | 6 +++---
 drivers/media/platform/exynos4-is/Kconfig     | 2 +-
 drivers/media/platform/exynos4-is/fimc-core.c | 2 ++
 drivers/media/platform/s5p-jpeg/jpeg-core.c   | 6 +++++-
 drivers/media/platform/s5p-tv/Kconfig         | 2 +-
 drivers/media/platform/vivid/Kconfig          | 5 ++++-
 drivers/media/platform/vivid/vivid-tpg.c      | 2 +-
 drivers/media/radio/wl128x/fmdrv_common.c     | 2 +-
 drivers/media/tuners/xc5000.c                 | 2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         | 6 +++---
 drivers/media/usb/dvb-usb-v2/anysee.c         | 6 +++---
 drivers/media/usb/em28xx/em28xx-core.c        | 2 +-
 drivers/media/usb/em28xx/em28xx-input.c       | 4 +++-
 drivers/media/usb/hackrf/hackrf.c             | 2 +-
 drivers/media/usb/usbvision/usbvision-video.c | 2 ++
 drivers/media/usb/uvc/uvc_v4l2.c              | 1 -
 drivers/media/usb/uvc/uvc_video.c             | 2 +-
 drivers/media/usb/uvc/uvcvideo.h              | 1 -
 drivers/media/v4l2-core/videobuf-dma-contig.c | 9 +++++++++
 include/uapi/linux/v4l2-dv-timings.h          | 9 +++++++++
 25 files changed, 62 insertions(+), 27 deletions(-)

