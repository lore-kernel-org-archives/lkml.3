Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945969Ab3FUTtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:49:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945935Ab3FUTtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:49:45 -0400
Date: Fri, 21 Jun 2013 16:49:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.10-rc7] media fixes
Message-ID: <20130621164941.0fe3f4f1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For another set of fixes for Kernel 3.10.

This series contain:
	- two Kbuild fixes for randconfig;
	- a buffer overflow when using rtl28xuu with r820t tuner;
	- one clk fixup on exynos4-is driver.

Thank you!
Mauro

-

The following changes since commit af44ad5edd1eb6ca92ed5be48e0004e1f04bf219:

  [media] soc_camera: error dev remove and v4l2 call (2013-06-08 21:51:06 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to bb69ee27b96110c509d5b92c9ee541d81a821706:

  [media] Fix build when drivers are builtin and frontend modules (2013-06-20 10:35:53 -0300)

----------------------------------------------------------------
Gianluca Gennari (1):
      [media] rtl28xxu: fix buffer overflow when probing Rafael Micro r820t tuner

Mauro Carvalho Chehab (2):
      [media] s5p makefiles: don't override other selections on obj-[ym]
      [media] Fix build when drivers are builtin and frontend modules

Sylwester Nawrocki (1):
      [media] exynos4-is: Fix FIMC-IS clocks initialization

 drivers/media/Kconfig                       | 12 +++++++++---
 drivers/media/platform/exynos4-is/fimc-is.c | 26 ++++++++------------------
 drivers/media/platform/exynos4-is/fimc-is.h |  1 -
 drivers/media/platform/s5p-jpeg/Makefile    |  2 +-
 drivers/media/platform/s5p-mfc/Makefile     |  2 +-
 drivers/media/tuners/Kconfig                | 20 --------------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |  6 +++---
 7 files changed, 22 insertions(+), 47 deletions(-)

