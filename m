Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaDWODt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:03:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57887 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbaDWOBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:01:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/5] Berlin: add clock support
Date: Wed, 23 Apr 2014 16:01:02 +0200
Message-Id: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the clocks having their own register set. Other
clocks are available but they are sharing a common register in addition of their
own registers. They will be supported in a following series.

Also, I realized that when moving the pll nodes out of the clocks container,
they didn't get reorder.

Alexandre Belloni (5):
  clk: berlin: add support for clocks
  clk: berlin: add berlin clocks DT bindings documentation
  ARM: berlin/dt: add sdio clocks to BG2
  ARM: berlin/dt: add sdio clocks to BG2CD
  ARM: berlin/dt: add sdio clocks to BG2Q

 .../devicetree/bindings/clock/berlin-clock.txt     |   9 +-
 arch/arm/boot/dts/berlin2.dtsi                     |  42 ++++---
 arch/arm/boot/dts/berlin2cd.dtsi                   |  42 ++++---
 arch/arm/boot/dts/berlin2q.dtsi                    |  28 +++--
 drivers/clk/berlin/Makefile                        |   2 +-
 drivers/clk/berlin/clk.c                           | 132 +++++++++++++++++++++
 6 files changed, 218 insertions(+), 37 deletions(-)
 create mode 100644 drivers/clk/berlin/clk.c

-- 
1.9.1

