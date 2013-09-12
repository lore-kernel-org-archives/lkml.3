Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3ILQvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:51:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38115 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3ILQvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:51:06 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/2] arm: zynq: Enable global timer
Date: Thu, 12 Sep 2013 09:50:38 -0700
Message-Id: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm sitting on this for a while and was waiting for Stephen's patch to
get merged somewhere. Unfortunately that didn't happen yet.
The patch to enable the global timer is pretty straight forward.
Stephen's patch is the result of this thread: https://lkml.org/lkml/2013/7/22/649
and required to prevent the global_timer from becoming the broadcast
device, since the system will hang otherwise.

Soren Brinkmann (1):
  arm: zynq: Enable arm_global_timer

Stephen Boyd (1):
  tick: broadcast: Deny per-cpu clockevents from being broadcast sources

 arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++++++
 arch/arm/mach-zynq/Kconfig       | 1 +
 kernel/time/tick-broadcast.c     | 3 +++
 3 files changed, 12 insertions(+)

-- 
1.8.4

