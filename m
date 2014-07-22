Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaGVOwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:52:46 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56353 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaGVOwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:52:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, dbaryshkov@gmail.com
Subject: [PATCH 0/5] power: reset: Add support for ST's boards
Date: Tue, 22 Jul 2014 15:52:27 +0100
Message-Id: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set provides device reset support for Orly2 and Cannes. 

Lee Jones (5):
  power: reset: Add restart functionality for STiH41x platforms
  power: reset: st: Provide DT bindings for ST's Power Reset driver
  ARM: sti: Add Restart support for the STiH417 (Cannes) board
  ARM: sti: Add Restart support for the STiH416 (Orly2) board
  ARM: multi_v7_defconfig: Enable ST's Power Reset driver

 .../devicetree/bindings/power/reset/st-reset.txt   |  11 ++
 arch/arm/boot/dts/stih407.dtsi                     |   6 +
 arch/arm/boot/dts/stih416.dtsi                     |   6 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/power/reset/Kconfig                        |   6 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/st-poweroff.c                  | 151 +++++++++++++++++++++
 7 files changed, 182 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/st-reset.txt
 create mode 100644 drivers/power/reset/st-poweroff.c

-- 
1.8.3.2

