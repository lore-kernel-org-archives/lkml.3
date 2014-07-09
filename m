Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaGIJEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:04:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35763 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaGIJEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:04:47 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <galak@codeaurora.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <george.cherian@ti.com>
Subject: [PATCH v2 0/2] Add devicetree support for extcon-gpio
Date: Wed, 9 Jul 2014 14:31:06 +0530
Message-ID: <1404896468-15974-1-git-send-email-george.cherian@ti.com>
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

 .../devicetree/bindings/extcon/extcon-gpio.txt     | 21 ++++++++++++
 drivers/extcon/extcon-gpio.c                       | 38 +++++++++++++++++++---
 include/linux/extcon/extcon-gpio.h                 |  4 ++-
 3 files changed, 57 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt

-- 
1.8.3.1

