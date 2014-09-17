Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaIQMeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:34:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48384 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbaIQMe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:34:27 -0400
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: Sebastian Reichel <sre@kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] mfd: twl4030-power: support ti,system-power-controller
Date: Wed, 17 Sep 2014 07:34:10 -0500
Message-ID: <1410957252-764-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds ti,system-power-controller to Documentation and the
driver seperately as per maintainer preference.

Based on v3.17-rc1

Changes since V1: update in documentation, picked up Tony's ack for patch #2.

V1: http://marc.info/?l=devicetree&m=140977126218800&w=2

Nishanth Menon (2):
  Documentation: devicetree: mfd: twl4030-power: Use the standard
    'ti,system-power-controller' to mark power control
  mfd: twl4030-power: use 'ti,system-power-controller' as alternative
    way to support system power off

 .../devicetree/bindings/mfd/twl4030-power.txt      |    9 +++++++--
 drivers/mfd/twl4030-power.c                        |    3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
1.7.9.5

