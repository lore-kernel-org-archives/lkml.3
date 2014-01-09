Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaAIQtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:49:20 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:52086 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaAIQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:49:11 -0500
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
To: <anton@enomsg.org>, <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Cc: <mk7.kang@samsung.com>
Subject: [PATCH 0/3] power_supply: modelgauge_battery: Add Maxim ModelGauge ICs gauge
Date: Thu,  9 Jan 2014 20:49:02 +0400
Message-Id: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This adds the folowing:
- Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips
- Document DT bindings
- Remove superseded Maxim MAX17040 gauge driver

Vladimir Barinov (3):
 [1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs gauge
 [2/3] dt: Document ModelGauge gauge bindings
 [3/3] power_supply: modelgauge_battery: Remove Maxim MAX17040 gauge

---
 Documentation/devicetree/bindings/power_supply/modelgauge_battery.txt |   82 
 drivers/power/Kconfig                                                 |   16 
 drivers/power/Makefile                                                |    2 
 drivers/power/max17040_battery.c                                      |  297 ---
 drivers/power/modelgauge_battery.c                                    |  875 ++++++++++
 include/linux/platform_data/battery-modelgauge.h                      |   44 
 6 files changed, 1010 insertions(+), 306 deletions(-)
