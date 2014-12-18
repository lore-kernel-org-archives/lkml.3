Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaLRCAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:00:00 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15150 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaLRB76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:59:58 -0500
X-IronPort-AV: E=Sophos;i="5.07,597,1413270000"; 
   d="scan'208";a="53340644"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Ray Jui <rjui@broadcom.com>, Jonathan Richardson <jonathar@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: [PATCH 0/2]  Add support for Broadcom iProc touchscreen
Date: Wed, 17 Dec 2014 17:59:50 -0800
Message-ID: <1418867992-3550-1-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Jonathan Richardson <jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains initial support for the touchscreen on the Broadcom
iProc family of SoCs. This driver has been validated with Cygnus and is expected
to work on other iProc family of SoCs that use the same touchscreen controller.

Jonathan Richardson (2):
  Input: touchscreen-iproc: Add Broadcom iProc touchscreen driver
  Input: touchscreen-iproc: add device tree bindings

 .../input/touchscreen/brcm,iproc-touchscreen.txt   |   70 +++
 drivers/input/touchscreen/Kconfig                  |   11 +
 drivers/input/touchscreen/Makefile                 |    1 +
 drivers/input/touchscreen/bcm_iproc_tsc.c          |  559 ++++++++++++++++++++
 4 files changed, 641 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/brcm,iproc-touchscreen.txt
 create mode 100644 drivers/input/touchscreen/bcm_iproc_tsc.c

-- 
1.7.9.5

