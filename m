Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3KVQXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:23:19 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37613 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3KVQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:23:18 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com
Cc: linus.walleij@linaro.org
Subject: [PATCH 00/23] mtd: st_spi_fsm: Add new device
Date: Fri, 22 Nov 2013 16:22:37 +0000
Message-Id: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first bunch of these patches have been on the MLs before, but 
didn't receive a great deal of attention for the most part. We are
a little more featureful this time however. We can now successfully
setup and configure the N25Q256. We still can't read/write/erase
it though. I'll start work on that next week and will provide it in
the next instalment.

 arch/arm/boot/dts/stih416-b2105.dts     |  14 +++
 arch/arm/boot/dts/stih416-pinctrl.dtsi  |  12 ++
 drivers/mtd/devices/Kconfig             |   7 ++
 drivers/mtd/devices/Makefile            |   1 +
 drivers/mtd/devices/serial_flash_cmds.h |  91 ++++++++++++++
 drivers/mtd/devices/st_spi_fsm.c        | 737 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h        | 419 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1281 insertions(+)


