Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3LFCTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:19:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33917 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3LFCSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:18:54 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH RESEND v5 0/4] LP3943 MFD driver for a GPIO expander and a PWM generator
Date: Fri, 6 Dec 2013 11:18:40 +0900
Message-ID: <1386296324-23039-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP3943 is an integrated device capable of driving 16 output channels.
It can be used for GPIO expander and PWM generators.
LP3493 registers are controlled via the I2C interface.

This patch-set consists of four parts - MFD, GPIO, PWM and documents.

Update from v4 to v5:
  Add Thierry's ACK for the PWM driver and the DT documentation

Milo Kim (4):
  mfd: add LP3943 MFD driver
  gpio: add LP3943 I2C GPIO expander driver
  pwm: add LP3943 PWM driver
  Documentation: add LP3943 DT bindings and document

 .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 +++
 Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 ++
 .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-lp3943.c                         |  242 +++++++++++++++
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/lp3943.c                               |  167 +++++++++++
 drivers/pwm/Kconfig                                |   10 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-lp3943.c                           |  314 ++++++++++++++++++++
 include/linux/mfd/lp3943.h                         |  114 +++++++
 13 files changed, 997 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
 create mode 100644 drivers/gpio/gpio-lp3943.c
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 drivers/pwm/pwm-lp3943.c
 create mode 100644 include/linux/mfd/lp3943.h

-- 
1.7.10.4

