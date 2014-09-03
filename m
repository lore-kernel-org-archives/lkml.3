Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaICTG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:06:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47554 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbaICTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:06:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] mfd: twl4030-power: support ti,system-power-controller
Date: Wed, 3 Sep 2014 14:06:46 -0500
Message-ID: <1409771208-21867-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds ti,system-power-controller to Documentation and the
driver seperately as per maintainer preference.

Based on v3.17-rc1

Nishanth Menon (2):
  Documentation: devicetree: mfd: twl4030-power: Use the standard
    'ti,system-power-controller' to mark power control
  mfd: twl4030-power: use 'ti,system-power-controller' as alternative
    way to support system power off

 .../devicetree/bindings/mfd/twl4030-power.txt      |    7 +++++--
 drivers/mfd/twl4030-power.c                        |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
1.7.9.5

