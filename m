Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaEOSd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:33:26 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41582 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbaEOSdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:33:23 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: marc.ceeeee@gmail.com, computersforpeace@gmail.com, gregory.0xf0@gmail.com,
        arnd@arndb.de, Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH 0/3 v2] bus: add Broadcom GISB bus arbiter timeout/error handler
Date: Thu, 15 May 2014 11:32:46 -0700
Message-Id: <1400178769-10448-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch adds support for the Broadcom GISB bus arbiter timeout/error handler.
GISB is a custom and proprietary bus used in the Broadcom Set Top Box devices
exclusively. The bus arbiter offers the possibly to decode faulting masters as
well as masters that are timing out on the bus.

V2 addresses some comments made by Arnd, and widens the audience by posting
on linux-arm-kernel as well.

Florian Fainelli (3):
  bus: add Broadcom GISB arbiter bus timeout/error handler
  Documentation: devicetree: add Broadcom GISB arbiter bindings
  Documentation: sysfs: add Broadcom GISB arbiter sysfs properties

 .../ABI/testing/sysfs-platform-brcmstb-gisb-arb    |   8 +
 .../devicetree/bindings/bus/brcm,gisb-arb.txt      |  30 +++
 drivers/bus/Kconfig                                |  11 +-
 drivers/bus/Makefile                               |   1 +
 drivers/bus/brcmstb_gisb.c                         | 289 +++++++++++++++++++++
 5 files changed, 338 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-brcmstb-gisb-arb
 create mode 100644 Documentation/devicetree/bindings/bus/brcm,gisb-arb.txt
 create mode 100644 drivers/bus/brcmstb_gisb.c

-- 
1.9.1

