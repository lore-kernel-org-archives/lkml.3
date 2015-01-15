Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbbAOWQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:16:53 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57828 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753511AbbAOWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:16:52 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/5] AT91: switch to multiplatform
Date: Thu, 15 Jan 2015 23:16:44 +0100
Message-Id: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set switches all AT91 SoCs to multiplatform then proceed to further
cleanup.

Alexandre Belloni (5):
  ARM: at91: switch to multiplatform
  ARM: at91: switch at91_dt_defconfig to multiplatform
  ARM: at91: remove unused uncompress.h
  ARM: at91: sama5d4: copy defines to SoC file
  ARM: at91: remove useless SoC includes

 arch/arm/Kconfig                              |  13 --
 arch/arm/configs/at91_dt_defconfig            |   5 +-
 arch/arm/mach-at91/Kconfig                    | 114 +++++++-------
 arch/arm/mach-at91/Makefile                   |   2 +
 arch/arm/mach-at91/include/mach/at91rm9200.h  | 103 ------------
 arch/arm/mach-at91/include/mach/at91sam9260.h | 129 ---------------
 arch/arm/mach-at91/include/mach/at91sam9261.h |  99 ------------
 arch/arm/mach-at91/include/mach/at91sam9263.h | 117 --------------
 arch/arm/mach-at91/include/mach/at91sam9g45.h | 143 -----------------
 arch/arm/mach-at91/include/mach/at91sam9n12.h |  65 --------
 arch/arm/mach-at91/include/mach/at91sam9rl.h  | 105 -------------
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |  71 ---------
 arch/arm/mach-at91/include/mach/hardware.h    |  11 --
 arch/arm/mach-at91/include/mach/sama5d3.h     |  86 ----------
 arch/arm/mach-at91/include/mach/sama5d4.h     |  33 ----
 arch/arm/mach-at91/include/mach/uncompress.h  | 218 --------------------------
 arch/arm/mach-at91/sama5d4.c                  |  12 +-
 17 files changed, 77 insertions(+), 1249 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91rm9200.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9260.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9261.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9263.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9g45.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9n12.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9rl.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5.h
 delete mode 100644 arch/arm/mach-at91/include/mach/sama5d3.h
 delete mode 100644 arch/arm/mach-at91/include/mach/sama5d4.h
 delete mode 100644 arch/arm/mach-at91/include/mach/uncompress.h

-- 
2.1.0

