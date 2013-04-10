Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936532Ab3DJWVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:21:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724Ab3DJWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:53 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 0/6] DMA: shdma: add Device Tree support
Date: Thu, 11 Apr 2013 00:19:43 +0200
Message-Id: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:fC36TX6rBJCx6PrpzT38J8x6lFqk6AFQULLIkiOFt+X
 FmC4qv0ifNRjbucmN0EDPwasMgjDovB75wX10rYDTojhAsICXj
 MuOpmgENK/UsnA4d822kX3QtoEIuLLCAIRviS7oIELCD+KTMly
 PfH5x3Xi70Q8v4qViH8Sk8Lqe0yxTm9N+EcOxYGV44G/p/aU/v
 msW6KII6jamTZrq/mxOki+vM6zRPj9Ho1ARZAAgMwpQaZDP0wq
 96FZrlatf+DH7NrBMCXv82BtNUu7fgS7+JcxBI8LxwgFjKbZNp
 PIeQXfEYeULgX6j5Z+YLHq7EJ/k1DlZhYLrL7gX5tSxwAz2qHD
 BcnqFRoaru6HxVfAmKx5XKrf5Xf2syatZaWJJDQYOeAe78A0s4
 GtRuXl8ib9teQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds Device Tree support to the shdma dmaengine driver 
and illustraits its use with the kzm9g-reference board's MMCIF interface.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (6):
  DMA: shdma: (cosmetic) don't re-calculate a pointer
  DMA: shdma: shdma_chan_filter() has to be in shdma-base.h
  DMA: shdma: add DT support
  ARM: shmobile: sh73a0: add support for the DMA0 controller in DT
  mmc: sh_mmcif: add support for Device Tree DMA bindings
  ARM: shmobile: kzm9g-reference: add DMA channels to the MMCIF DT

 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts |    3 ++
 arch/arm/boot/dts/sh73a0.dtsi                |   36 ++++++++++++++++++
 arch/arm/mach-shmobile/setup-sh73a0.c        |    4 ++
 drivers/dma/sh/shdma-base.c                  |   51 +++++++++++++++++++++++---
 drivers/dma/sh/shdma.c                       |   46 ++++++++++++++++++++----
 drivers/mmc/host/sh_mmcif.c                  |   29 +++++++++------
 include/linux/sh_dma.h                       |    2 -
 include/linux/shdma-base.h                   |    6 +++
 8 files changed, 151 insertions(+), 26 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
