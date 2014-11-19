Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaKSKbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:31:17 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52376 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaKSKbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:31:16 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/4] ARM: at91: remove !DT support for at91sam9260/9g20 and at91sam9263
Date: Wed, 19 Nov 2014 11:31:10 +0100
Message-ID: <cover.1416392687.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As announced here https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91:
removal of board files) two months ago, we are continuing the work to remove
the non-Device-Tree board support for older Atmel SoCs.
This series is for at91sam9260/9g20 and at91sam9263. The DT must be used for
these SoCs.

The diffstat is pretty big this time.

Bye,

Nicolas Ferre (4):
  ARM: at91: remove at91sam9263 legacy board support
  ARM: at91: remove at91sam9260/at91sam9g20 legacy boards files
  ARM: at91: remove at91sam9260/at91sam9g20 legacy board support
  ARM: at91/Kconfig: remove unused config options

 arch/arm/configs/at91sam9260_9g20_defconfig |  145 ---
 arch/arm/configs/at91sam9263_defconfig      |  151 ---
 arch/arm/mach-at91/Kconfig.non_dt           |  138 ---
 arch/arm/mach-at91/Makefile                 |   24 -
 arch/arm/mach-at91/at91sam9260.c            |  397 -------
 arch/arm/mach-at91/at91sam9260_devices.c    | 1364 ------------------------
 arch/arm/mach-at91/at91sam9263.c            |  399 -------
 arch/arm/mach-at91/at91sam9263_devices.c    | 1538 ---------------------------
 arch/arm/mach-at91/board-afeb-9260v1.c      |  223 ----
 arch/arm/mach-at91/board-cam60.c            |  199 ----
 arch/arm/mach-at91/board-cpu9krea.c         |  386 -------
 arch/arm/mach-at91/board-flexibity.c        |  171 ---
 arch/arm/mach-at91/board-gsia18s.c          |  585 ----------
 arch/arm/mach-at91/board-pcontrol-g20.c     |  228 ----
 arch/arm/mach-at91/board-sam9-l9260.c       |  230 ----
 arch/arm/mach-at91/board-sam9260ek.c        |  354 ------
 arch/arm/mach-at91/board-sam9263ek.c        |  493 ---------
 arch/arm/mach-at91/board-sam9g20ek.c        |  429 --------
 arch/arm/mach-at91/board-snapper9260.c      |  191 ----
 arch/arm/mach-at91/board-stamp9g20.c        |  294 -----
 arch/arm/mach-at91/stamp9g20.h              |    7 -
 drivers/misc/Kconfig                        |    2 +-
 drivers/rtc/Kconfig                         |    4 +-
 drivers/video/backlight/Kconfig             |    1 -
 24 files changed, 2 insertions(+), 7951 deletions(-)
 delete mode 100644 arch/arm/configs/at91sam9260_9g20_defconfig
 delete mode 100644 arch/arm/configs/at91sam9263_defconfig
 delete mode 100644 arch/arm/mach-at91/at91sam9260_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9263_devices.c
 delete mode 100644 arch/arm/mach-at91/board-afeb-9260v1.c
 delete mode 100644 arch/arm/mach-at91/board-cam60.c
 delete mode 100644 arch/arm/mach-at91/board-cpu9krea.c
 delete mode 100644 arch/arm/mach-at91/board-flexibity.c
 delete mode 100644 arch/arm/mach-at91/board-gsia18s.c
 delete mode 100644 arch/arm/mach-at91/board-pcontrol-g20.c
 delete mode 100644 arch/arm/mach-at91/board-sam9-l9260.c
 delete mode 100644 arch/arm/mach-at91/board-sam9260ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9263ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9g20ek.c
 delete mode 100644 arch/arm/mach-at91/board-snapper9260.c
 delete mode 100644 arch/arm/mach-at91/board-stamp9g20.c
 delete mode 100644 arch/arm/mach-at91/stamp9g20.h

-- 
2.1.3

