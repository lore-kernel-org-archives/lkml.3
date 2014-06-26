Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaFZH2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:28:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35675 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaFZH2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:28:10 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 0/2] arm: dts: dra7: add crossbar dt support 
Date: Thu, 26 Jun 2014 12:55:29 +0530
Message-ID: <1403767532-19290-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces DT support for crossbar device and
changes dra7 peripherals to use crossbar number instead of irq.

This depends on below driver fixes and cleanup series.
http://marc.info/?l=linux-omap&m=140376708127157&w=2

[V2] Rebased on 3.15 mainline.
[V3] Added ti,irqs-skip property and ti,irqs-safe-map property to
     crossbar dt node.
[V4] Introduced macros MAX_SOURCES and DIRECT_IRQ

R Sricharan (2):
  arm: dts: dra7: add routable-irqs property for gic node
  arm: dts: dra7: add crossbar device binding

 arch/arm/boot/dts/dra7.dtsi |  139 +++++++++++++++++++++++++------------------
 1 file changed, 81 insertions(+), 58 deletions(-)

-- 
1.7.9.5
