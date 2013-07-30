Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3G3Ama (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:42:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41939 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab3G3AmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:42:24 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: [PATCH v2 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Thread-Topic: [PATCH v2 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Thread-Index: Ac6MtPwZD9EP5HyaSpa1yZpmewoqqw==
Date: Tue, 30 Jul 2013 00:42:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E849D1@DQHE06.ent.ti.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6U0gqOD030758

LP3943 is an integrated device capable of driving 16 output channels.
It can be used for GPIO expander and PWM generators.
LP3493 registers are controlled via the I2C interface.

This patch-set consists of four parts - MFD, GPIO, PWM and device tree bindings.

Milo Kim (4):
  mfd: add LP3943 MFD driver
  gpio: add LP3943 I2C GPIO expander driver
  pwm: add LP3943 PWM driver
  Documentation: dt: bindings: add LP3943 bindings

 .../devicetree/bindings/gpio/gpio-lp3943.txt       |   42 +++
 Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 ++
 .../devicetree/bindings/pwm/pwm-lp3943.txt         |   65 ++++
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-lp3943.c                         |  242 ++++++++++++++
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/lp3943.c                               |  165 ++++++++++
 drivers/pwm/Kconfig                                |   10 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-lp3943.c                           |  348 ++++++++++++++++++++
 include/linux/mfd/lp3943.h                         |  115 +++++++
 13 files changed, 1042 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
 create mode 100644 drivers/gpio/gpio-lp3943.c
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 drivers/pwm/pwm-lp3943.c
 create mode 100644 include/linux/mfd/lp3943.h

-- 
1.7.9.5


Best Regards,
Milo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
