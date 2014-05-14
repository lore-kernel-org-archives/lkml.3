Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaENTNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:13:01 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56207 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaENTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:11:18 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: marc.ceeeee@gmail.com, computersforpeace@gmail.com, gregory.0xf0@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH 0/3] bus: add Broadcom GISB bus arbiter timeout/error handler
Date: Wed, 14 May 2014 12:10:45 -0700
Message-Id: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch adds support for the Broadcom GISB bus arbiter timeout/error handler.
GISB is a custom and proprietary bus used in the Broadcom Set Top Box devices
exclusively. The bus arbiter offers the possibly to decode faulting masters as
well as masters that are timing out on the bus.

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

