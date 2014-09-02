Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaIBIuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:50:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36130 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbaIBIuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:50:19 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/7] ARM: at91: update defconfigs
Date: Tue,  2 Sep 2014 10:49:56 +0200
Message-Id: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following recent work on the AT91 platforms, update the defconfigs to include
the new power and reset driver, the ADC and touchscreen driver, the new PWM
driver using the generic PWM framework.

Also remove deprecated options like CONFIG_PROC_DEVICETREE,
CONFIG_SCSI_MULTI_LUN, CONFIG_MII, CONFIG_MTD_CHAR.

Alexandre Belloni (7):
  ARM: at91: at91_dt: update defconfig
  ARM: at91: at91sam9260_9g20: update defconfig
  ARM: at91: at91sam9261_9g10: update defconfig
  ARM: at91: at91sam9263: update defconfig
  ARM: at91: at91sam9g45: update defconfig
  ARM: at91: at91sam9rl: update defconfig
  ARM: at91: sama5: update defconfig

 arch/arm/configs/at91_dt_defconfig          | 25 +++++++++++++------------
 arch/arm/configs/at91sam9260_9g20_defconfig | 13 +++++--------
 arch/arm/configs/at91sam9261_9g10_defconfig |  5 ++---
 arch/arm/configs/at91sam9263_defconfig      | 13 ++++++-------
 arch/arm/configs/at91sam9g45_defconfig      | 19 +++++++++++--------
 arch/arm/configs/at91sam9rl_defconfig       | 19 ++++++++++++++-----
 arch/arm/configs/sama5_defconfig            | 12 ++++++------
 7 files changed, 57 insertions(+), 49 deletions(-)

-- 
1.9.1

