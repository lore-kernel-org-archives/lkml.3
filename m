Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaHFElm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:41:42 -0400
Received: from s87.loopia.se ([194.9.94.112]:32088 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaHFEll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:41:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: joe@perches.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 00/15] fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:41:17 -0700
Message-Id: <1407300077-32113-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second round of fixes, covering all the instances found
with Joe Perches's regex from https://lkml.org/lkml/2014/8/3/128 in
linux-next.

I have tried to split it across the different subsystems and address
the appropriate folks on each patch.

Hans Wennborg (15):
  sparc: fix decimal printf format specifiers prefixed with 0x
  cpufreq: fix decimal printf format specifiers prefixed with 0x
  iommu/arm-smmu: fix decimal printf format specifiers prefixed with 0x
  [media] dvb: fix decimal printf format specifiers prefixed with 0x
  mfd: rtsx_usb: fix decimal printf format specifiers prefixed with 0x
  vmxnet3: fix decimal printf format specifiers prefixed with 0x
  mwifiex: fix decimal printf format specifiers prefixed with 0x
  rtlwifi: rtl8192de: fix decimal printf format specifiers prefixed with 0x
  pinctrl: pinctrl-at91.c: fix decimal printf format specifiers prefixed with 0x
  scsi: fix decimal printf format specifiers prefixed with 0x
  TTY: fix decimal printf format specifiers prefixed with 0x
  usb: musb: ux500: fix decimal printf format specifiers prefixed with 0x
  exofs: fix decimal printf format specifiers prefixed with 0x
  xfs: fix decimal printf format specifiers prefixed with 0x
  ASoC: fix decimal printf format specifiers prefixed with 0x

 arch/sparc/kernel/smp_32.c                  | 2 +-
 drivers/cpufreq/speedstep-smi.c             | 4 ++--
 drivers/iommu/arm-smmu.c                    | 2 +-
 drivers/media/dvb-frontends/mb86a16.c       | 2 +-
 drivers/mfd/rtsx_usb.c                      | 2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c           | 2 +-
 drivers/net/wireless/mwifiex/cfg80211.c     | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c | 2 +-
 drivers/pinctrl/pinctrl-at91.c              | 4 ++--
 drivers/scsi/cxgbi/libcxgbi.c               | 2 +-
 drivers/scsi/nsp32.c                        | 2 +-
 drivers/scsi/qla2xxx/qla_target.c           | 2 +-
 drivers/tty/moxa.c                          | 2 +-
 drivers/usb/musb/ux500_dma.c                | 2 +-
 fs/exofs/dir.c                              | 2 +-
 fs/xfs/xfs_discard.c                        | 2 +-
 sound/soc/atmel/atmel_ssc_dai.c             | 2 +-
 sound/soc/sh/dma-sh7760.c                   | 2 +-
 sound/soc/sh/rcar/gen.c                     | 6 +++---
 19 files changed, 23 insertions(+), 23 deletions(-)

-- 
2.0.0.526.g5318336

