Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaDDXOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:14:40 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63065 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaDDXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:14:38 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v2 0/5] ARM: zynq: DT update
Date: Fri,  4 Apr 2014 16:14:11 -0700
Message-Id: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's the complete series now. One fix for cpufreq from our vendor tree
and migration to pre-processor syntax.

	Thanks,
	Sören

Changes in v2:
 - Send full series (added patches 1, 4, 5)

Soren Brinkmann (5):
  ARM: zynq: DT: Add 'clock-latency' property
  ARM: zynq: dt: Convert to preprocessor includes
  ARM: zynq: dt: Use #defines for interrupt specifiers
  dt-bindings: clock: Add Zynq-7000 header
  ARM: zynq: dt: Use #defines for clock specifiers

 arch/arm/boot/dts/zynq-7000.dtsi      | 64 ++++++++++++++++++++++-------------
 arch/arm/boot/dts/zynq-zc702.dts      |  2 +-
 arch/arm/boot/dts/zynq-zc706.dts      |  2 +-
 arch/arm/boot/dts/zynq-zed.dts        |  2 +-
 include/dt-bindings/clock/zynq-7000.h | 64 +++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 27 deletions(-)
 create mode 100644 include/dt-bindings/clock/zynq-7000.h

-- 
1.9.1.1.gbb9f595

