Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaFQEBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:01:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaFQEA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:00:58 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <galak@codeaurora.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <george.cherian@ti.com>
Subject: [PATCH 0/2] Add devicetree support for extcon-gpio
Date: Tue, 17 Jun 2014 09:28:18 +0530
Message-ID: <1402977500-19987-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serires adds devicetree support for extcon-gpio driver.

Patch 1 - Addreses minor cleanups
Patch 2 - Adds devicetree support for esxtcon-gpio driver.
 
George Cherian (2):
  extcon: gpio: Minor cleanups
  extcon: gpio: Add dt support for the driver.

 .../devicetree/bindings/extcon/extcon-gpio.txt     | 34 +++++++++++++++++++
 drivers/extcon/extcon-gpio.c                       | 39 +++++++++++++++++++---
 include/linux/extcon/extcon-gpio.h                 |  4 ++-
 3 files changed, 71 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt

-- 
1.8.3.1

