Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaFPMMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:12:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43448 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFPMMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:12:50 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 0/2] arm: dts: dra7: add crossbar dt support
Date: Mon, 16 Jun 2014 17:40:20 +0530
Message-ID: <1402920622-7998-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces DT support for crossbar device and
changes dra7 peripherals to use crossbar number instead of irq.

This depends on below driver fixes and cleanup series.

https://lkml.org/lkml/2014/6/16/218

[V2] Rebased on 3.15 mainline.
[V3] Added ti,irqs-skip property and ti,irqs-safe-map property to
     crossbar dt node.

R Sricharan (2):
  arm: dts: dra7: add routable-irqs property for gic node
  arm: dts: dra7: add crossbar device binding

 arch/arm/boot/dts/dra7.dtsi |  136 +++++++++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 58 deletions(-)

-- 
1.7.9.5

