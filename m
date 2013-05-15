Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab3EOJwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:52:16 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64773 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3EOJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 00/39] Continuation of DMA changes in ux500 based drivers
Date: Wed, 15 May 2013 10:51:23 +0100
Message-Id: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A great deal of these patches have now been applied through various trees.
We now need to grab the attention of the outstanding DMA clients (MUSB and
Crypto) to progress.

Also, Linus could probably do with a hand from Vinod for the remaining
dmaengine patches.

Thanks in advance.

 Documentation/devicetree/bindings/dma/ste-dma40.txt |    4 ++
 Documentation/devicetree/bindings/usb/ux500-usb.txt |   50 ++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-audio.c            |   12 ++---
 arch/arm/mach-ux500/board-mop500-sdi.c              |   16 +++---
 arch/arm/mach-ux500/board-mop500.c                  |   36 +++++--------
 arch/arm/mach-ux500/cpu-db8500.c                    |   34 ++++--------
 arch/arm/mach-ux500/devices-db8500.c                |   80 ----------------------------
 arch/arm/mach-ux500/usb.c                           |   37 +++----------
 drivers/crypto/ux500/cryp/cryp.h                    |    7 ++-
 drivers/crypto/ux500/cryp/cryp_core.c               |   31 ++++++++++-
 drivers/crypto/ux500/hash/hash_alg.h                |    5 +-
 drivers/crypto/ux500/hash/hash_core.c               |   24 ++++++++-
 drivers/dma/ste_dma40.c                             |  292 +++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------
 drivers/dma/ste_dma40_ll.c                          |  189 +++++++++++++++++++++++++++++++++--------------------------------
 drivers/dma/ste_dma40_ll.h                          |    3 +-
 drivers/usb/musb/ux500.c                            |   61 ++++++++++++++++++++-
 drivers/usb/musb/ux500_dma.c                        |   59 ++++++++++++---------
 include/linux/platform_data/dma-ste-dma40.h         |   25 ++-------
 include/linux/platform_data/usb-musb-ux500.h        |    5 +-
 sound/soc/ux500/ux500_pcm.c                         |   10 ++--
 20 files changed, 506 insertions(+), 474 deletions(-)

