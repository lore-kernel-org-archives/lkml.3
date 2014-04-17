Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaDQJKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:10:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54653 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754592AbaDQJKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:10:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 0/2] ARM: sunxi: Add A31 High Speed Timer Support
Date: Thu, 17 Apr 2014 11:06:44 +0200
Message-Id: <1397725606-18000-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset enables support for the High Speed Timer IP found in the
Allwinner A31 SoCs.

These timers are asserted in reset, and are not associated with any
struct device, so we also add a small helper to the reset framework
along the way to be able to retrieve the reset controller from the
device tree directly.

Thanks,
Maxime

Changes from v2:
  - Rebased on top of 3.15-rc1

Changes from v1:
  - Rebased on top of 3.14-rc1 and reset/for_3.15

Maxime Ripard (2):
  clocksource: sun5i: Add support for reset controller
  ARM: sun6i: a31: Add support for the High Speed Timers

 .../devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt |  4 ++++
 arch/arm/boot/dts/sun6i-a31.dtsi                              | 11 +++++++++++
 drivers/clocksource/timer-sun5i.c                             |  6 ++++++
 3 files changed, 21 insertions(+)

-- 
1.9.1

