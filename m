Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3FQRYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:24:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3FQRYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:24:01 -0400
Date: Mon, 17 Jun 2013 13:30:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.10-rc7] V4L/DVB fixes
Message-ID: <20130617133016.1f59e16f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a series of fixes for Kernel 3.10. There are some usual driver fixes (mostly
on s5p/exynos playform drivers), plus some fixes at V4L2 core.

Thank you!
Mauro

Latest commit at the branch: 
af44ad5edd1eb6ca92ed5be48e0004e1f04bf219 [media] soc_camera: error dev remove and v4l2 call
The following changes since commit df90e2258950fd631cdbf322c1ee1f22068391aa:

  Merge branch 'devel-for-v3.10' into v4l_for_linus (2013-04-30 09:01:04 -0300)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to af44ad5edd1eb6ca92ed5be48e0004e1f04bf219:

  [media] soc_camera: error dev remove and v4l2 call (2013-06-08 21:51:06 -0300)

----------------------------------------------------------------
Andrzej Hajda (3):
      [media] s5p-mfc: separate encoder parameters for h264 and mpeg4
      [media] s5p-mfc: v4l2 controls setup routine moved to initialization code
      [media] s5p-mfc: added missing end-of-lines in debug messages

Arnd Bergmann (1):
      [media] radio-si476x: depend on SND_SOC

Arun Kumar K (2):
      [media] s5p-mfc: Update v6 encoder buffer alloc
      [media] s5p-mfc: Remove special clock usage in driver

Axel Lin (2):
      [media] s5c73m3: Fix off-by-one valid range checking for fie->index
      [media] exynos4-is: Fix off-by-one valid range checking for is->config_index

Geert Uytterhoeven (1):
      [media] v4l2: SI476X MFD - Do not use binary constants

Hans Verkuil (6):
      [media] DocBook: media: update codec section, drop obsolete 'suspended' state
      [media] vpfe-capture.c: remove unused label probe_free_lock
      [media] DocBook/media/v4l: update version number
      [media] cx88: fix NULL pointer dereference
      [media] v4l2-ctrls: V4L2_CTRL_CLASS_FM_RX controls are also valid radio controls
      [media] v4l2-ioctl: don't print the clips list

Hans de Goede (2):
      [media] pwc: Fix comment wrt lock ordering
      [media] gspca-sonixb: Adjust hstart on sn9c103 + pas202

John Sheu (1):
      [media] v4l2: mem2mem: save irq flags correctly

Katsuya Matsubara (3):
      [media] sh_veu: invoke v4l2_m2m_job_finish() even if a job has been aborted
      [media] sh_veu: keep power supply until the m2m context is released
      [media] sh_veu: fix the buffer size calculation

Lad, Prabhakar (3):
      [media] media: davinci: vpbe: fix layer availability for NV12 format
      [media] davinci: vpfe: fix error path in probe
      [media] drivers/staging: davinci: vpfe: fix dependency for building the driver

Philipp Zabel (2):
      [media] v4l2-mem2mem: add v4l2_m2m_create_bufs helper
      [media] coda: v4l2-compliance fix: add VIDIOC_CREATE_BUFS support

Sachin Kamat (3):
      [media] exynos4-is: Fix potential null pointer dereference in mipi-csis.c
      [media] s3c-camif: Fix incorrect variable type
      [media] s5p-mfc: Add NULL check for allocated buffer

Seung-Woo Kim (2):
      [media] media: vb2: return for polling if a buffer is available
      [media] media: v4l2-mem2mem: return for polling if a buffer is available

Sylwester Nawrocki (6):
      [media] exynos4-is: Correct fimc-lite compatible property description
      [media] s5p-mfc: Remove unused s5p_mfc_get_decoded_status_v6() function
      [media] exynos4-is: Prevent NULL pointer dereference when firmware isn't loaded
      [media] exynos4-is: Ensure fimc-is clocks are not enabled until properly configured
      [media] exynos4-is: Fix reported colorspace at FIMC-IS-ISP subdev
      [media] exynos4-is: Remove "sysreg" clock handling

Wei Yongjun (1):
      [media] davinci: vpfe: fix error return code in vpfe_probe()

Wenbing Wang (1):
      [media] soc_camera: error dev remove and v4l2 call

Xiong Zhou (1):
      [media] staging/solo6x10: select the desired font

 Documentation/DocBook/media/v4l/dev-codec.xml      | 35 +++++----
 Documentation/DocBook/media/v4l/v4l2.xml           |  2 +-
 .../devicetree/bindings/media/exynos-fimc-lite.txt |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |  7 +-
 drivers/media/pci/cx88/cx88-video.c                |  8 +--
 drivers/media/platform/coda.c                      |  9 +++
 drivers/media/platform/davinci/vpbe_display.c      | 15 ++++
 drivers/media/platform/davinci/vpfe_capture.c      |  3 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |  2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        | 22 +++---
 drivers/media/platform/exynos4-is/fimc-is.h        |  1 -
 drivers/media/platform/exynos4-is/fimc-isp.c       |  4 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |  2 +-
 drivers/media/platform/s3c-camif/camif-core.h      |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  8 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h     |  4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 20 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 82 +++++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 53 ++++----------
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        | 23 +-----
 drivers/media/platform/sh_veu.c                    | 15 ++--
 drivers/media/platform/soc_camera/soc_camera.c     |  4 +-
 drivers/media/radio/Kconfig                        |  1 +
 drivers/media/radio/radio-si476x.c                 |  2 +-
 drivers/media/usb/gspca/sonixb.c                   |  7 ++
 drivers/media/usb/pwc/pwc.h                        |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  2 +
 drivers/media/v4l2-core/v4l2-ioctl.c               | 47 ++++++-------
 drivers/media/v4l2-core/v4l2-mem2mem.c             | 39 +++++++---
 drivers/media/v4l2-core/videobuf2-core.c           |  3 +-
 drivers/staging/media/davinci_vpfe/Kconfig         |  2 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  6 +-
 drivers/staging/media/solo6x10/Kconfig             |  1 +
 include/media/v4l2-mem2mem.h                       |  2 +
 38 files changed, 245 insertions(+), 206 deletions(-)

