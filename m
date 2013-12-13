Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3LMGnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:43:03 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:49869 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3LMGmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:42:46 -0500
From: Bo Shen <voice.shen@atmel.com>
To: thierry.reding@gmail.com
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        alexandre.belloni@free-electrons.com, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v9 0/2] PWM: pwm-atmel: add PWM controller driver
Date: Fri, 13 Dec 2013 14:41:48 +0800
Message-Id: <1386916910-24832-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add Atmel PWM controller driver support.

Changes in v9:
  - Address the comments from Thierry Reding

Changes in v8:
  - replace pr_err by dev_err

Changes in v7:
  - fix issue for none device tree issues.

Changes in v6:
  - using relaxed version for writel and readl
  - add none device tree support
  - change some define from lower case to upper case
  - split device tree binding document as a separate patch

Changes in v5:
  - call clk_disable directly, if so, it won't cause more than one channel
    enabled, the clock can not be disabled.

Changes in v4:
  - check the return value of clk_prepare()
  - change channel register size as constant

Changes in v3:
  - change compatible string from "atmel,sama5-pwm" to "atmel,sama5d3-pwm"
  - Add PWM led example in binding documentation
  - Using micro replace hard code

Changes in v2:
  - Address the comments from Thierry Reding


Bo Shen (2):
  PWM: atmel-pwm: add PWM controller driver
  PWM: atmel-pwm: add device tree binding document

 .../devicetree/bindings/pwm/atmel-pwm.txt          |   41 ++
 drivers/pwm/Kconfig                                |    9 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-atmel.c                            |  398 ++++++++++++++++++++
 4 files changed, 449 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel.c

-- 
1.7.9.5

