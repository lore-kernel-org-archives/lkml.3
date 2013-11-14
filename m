Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3KNOW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:22:59 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50062 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3KNOWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:22:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: [PATCH 00/10] mtd: st_spi_fsm: Add new device
Date: Thu, 14 Nov 2013 14:22:26 +0000
Message-Id: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First stab at getting this thing Mainlined. It doesn't do a great deal
yet, but we are able to initialise the device and dynamically set it up
correctly based on an extracted JEDEC ID.

 arch/arm/boot/dts/stih416-b2105.dts    |  10 ++
 arch/arm/boot/dts/stih416-pinctrl.dtsi |  12 +++
 drivers/mtd/devices/Kconfig            |   7 ++
 drivers/mtd/devices/Makefile           |   1 +
 drivers/mtd/devices/st_spi_fsm.c       | 605 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h       | 187 ++++++++++++++++++++++++++++++++
 6 files changed, 822 insertions(+)

