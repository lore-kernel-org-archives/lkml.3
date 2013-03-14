Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3CNL3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:29:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab3CNL3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:29:17 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] leds: replace macros with inline functions and
 support camera LED triggers
Thread-Topic: [PATCH v2 0/3] leds: replace macros with inline functions and
 support camera LED triggers
Thread-Index: Ac4gpybUJfBZ1zcOR7+zqI20oWSYog==
Date: Thu, 14 Mar 2013 11:29:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E488F7@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch v2
 (1) LED trigger macros are replaced with inline function in case of
     !CONFIG_LED_TRIGGERS and !CONFIG_LEDS_TRIGGER_IDE_DISK.
 (2) Use an inline function when CONFIG_LEDS_TRIGGER_CAMERA is not configured.

Patch v1
 Initial patch

Milo(Woogyom) Kim (3):
  leds: trigger: use inline functions instead of macros
  leds: add camera LED triggers
  leds: lm355x, lm3642: support camera LED triggers for flash and torch

 drivers/leds/leds-lm355x.c            |    2 ++
 drivers/leds/leds-lm3642.c            |    2 ++
 drivers/leds/trigger/Kconfig          |    8 +++++
 drivers/leds/trigger/Makefile         |    1 +
 drivers/leds/trigger/ledtrig-camera.c |   57 +++++++++++++++++++++++++++++++++
 include/linux/leds.h                  |   33 ++++++++++++-------
 include/linux/mmc/host.h              |    2 --
 7 files changed, 92 insertions(+), 13 deletions(-)
 create mode 100644 drivers/leds/trigger/ledtrig-camera.c

-- 
1.7.9.5


Best Regards,
Milo


