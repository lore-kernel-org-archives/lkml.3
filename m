Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaESSKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:10:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbaESSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:10:17 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv5 0/2] Add Allwinner SoCs PWM support
Date: Mon, 19 May 2014 20:10:01 +0200
Message-Id: <1400523003-27082-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds support for the PWM controller found on the Allwinner SoCs.

The first patch adds the driver itself.
The second patch adds the DT binding documentation

Changes in v5:
 - use GENMASK for all masks
 - use clk_prepare_enable()/clk_disable_unprepare() as the drier may sleep
   because of the mutex anyway

Alexandre Belloni (2):
  pwm: Add Allwinner SoC support
  pwm: sunxi: document OF bindings

 .../devicetree/bindings/pwm/pwm-sunxi.txt          |  20 ++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-sunxi.c                            | 338 +++++++++++++++++++++
 4 files changed, 368 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
 create mode 100644 drivers/pwm/pwm-sunxi.c

-- 
1.9.1

