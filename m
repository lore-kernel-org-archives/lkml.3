Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3EXOcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:32:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52513 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab3EXOc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:32:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <george.cherian@ti.com>, <kishon@ti.com>,
        <sameo@linux.intel.com>
Subject: [PATCH 0/3] palmas usb driver
Date: Fri, 24 May 2013 20:01:33 +0530
Message-ID: <1369405896-30246-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds driver for palmas usb which is used to detect
attach/detach events of usb device and usb host.

[PATCH v5 2/3] extcon: Palmas Extcon Driver which was sent previously
is added in this patch series itself. The revision history is added
in the patch comments section.

A checkpatch warning "WARNING: static const char * array should
probably be static const char * const"is ignored since it introduces a
compilation warning.

Graeme Gregory (2):
  drivers: regulator: palmas: add an API to set/clear the switch bit on
    SMPS10
  extcon: Palmas Extcon Driver

Kishon Vijay Abraham I (1):
  usb: dwc3: use extcon fwrk to receive connect/disconnect notification

 .../devicetree/bindings/extcon/extcon-twl.txt      |  16 +
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-palmas.c                     | 341 +++++++++++++++++++++
 drivers/regulator/palmas-regulator.c               |  26 ++
 drivers/usb/dwc3/dwc3-omap.c                       |  80 +++--
 include/linux/mfd/palmas.h                         |  27 +-
 include/linux/usb/dwc3-omap.h                      |  30 --
 8 files changed, 470 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-twl.txt
 create mode 100644 drivers/extcon/extcon-palmas.c
 delete mode 100644 include/linux/usb/dwc3-omap.h

-- 
1.8.1.2

