Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbaGOKJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:09:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51846 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbaGOKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:09:32 -0400
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Daniel Jeong <gshark.jeong@gmail.com>
Subject: [RFC v5 0/2]  backlight: add new tps611xx backlight driver
Date: Tue, 15 Jul 2014 19:09:16 +0900
Message-Id: <1405418958-7596-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver a general version for tps611xx backlgiht chips of TI.
It supports tps61158, tps61161, tps61163 and tps61165 backlight driver
based on EasyScale protocol.

Daniel Jeong (2):
  [RFC v5 1/2] backlight: add new tps611xx backlight driver
  [RFC v5 2/2] backlight: device tree: add new tps611xx backlight binding

 .../video/backlight/tps611xx-backlight.txt         |   26 ++
 drivers/video/backlight/Kconfig                    |    7 +
 drivers/video/backlight/Makefile                   |    1 +
 drivers/video/backlight/tps611xx_bl.c              |  479 ++++++++++++++++++++
 include/linux/platform_data/tps611xx_bl.h          |   31 ++
 5 files changed, 544 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/tps611xx-backlight.txt
 create mode 100644 drivers/video/backlight/tps611xx_bl.c
 create mode 100644 include/linux/platform_data/tps611xx_bl.h

-- 
1.7.9.5

