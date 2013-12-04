Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3LDSdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:33:38 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:37638 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889Ab3LDSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:33:37 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 0/4] Add missing components for X-Gene reboot drivers.
Date: Wed,  4 Dec 2013 10:32:59 -0800
Message-Id: <1386181979-26547-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dts node for X-Gene reboot driver. Apply documentation dts binding.
Some minor compile warning fix and enable reboot driver by default.

Feng Kan (4):
  Documentation: add dts binding for X-Gene reboot dts node.
  arm64: add missing dts entry for X-Gene platform.
  arm64: Enable system reset via arch Kconfig for X-Gene system.
  arm64: removed using of the mask attribute in the dts for reset bit.

 .../devicetree/bindings/arm64/xgene/reboot.txt     |   11 +++++++++++
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |    5 +++++
 drivers/power/reset/xgene-reboot.c                 |    5 ++---
 4 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm64/xgene/reboot.txt

-- 
1.7.6.1

