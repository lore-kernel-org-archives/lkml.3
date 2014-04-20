Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaDTIpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:45:45 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52308 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaDTIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:45:35 -0400
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 00/10] staging: rtl8188eu: Refactor and cleanup led related code.
Date: Sun, 20 Apr 2014 14:14:49 +0530
Message-Id: <5353892e.8482440a.6205.77a0@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

This patch series refactors and performs various cleanups on the driver's code
responsible for led functionality.

navin patidar (10):
  staging: rtl8188eu: Remove empty header file
  staging: rtl8188eu: Remove rtw_led_blink_cmd() function.
  staging: rtl8188eu: Remove _ReadLEDSetting() function.
  staging: rtl8188eu: Remove _InitHWLed() function.
  staging: rtl8188eu: Simplify led blinking strategy code.
  staging: rtl8188eu: Remove enum LED_STRATEGY_871x .
  staging: rtl8188eu: refactor led related structures.
  staging: rtl8188eu: Remove unused macros.
  staging: rtl8188eu: Remove unused enum LED_STATE_871x members.
  staging: rtl8188eu: Remove unused enum LED_CTL_MODE members.

 drivers/staging/rtl8188eu/core/rtw_cmd.c           |   35 -
 drivers/staging/rtl8188eu/core/rtw_led.c           | 1415 ++------------------
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c      |   43 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   26 -
 drivers/staging/rtl8188eu/include/drv_types.h      |    1 -
 .../staging/rtl8188eu/include/drv_types_linux.h    |   24 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |    1 -
 drivers/staging/rtl8188eu/include/rtw_led.h        |  119 +-
 8 files changed, 137 insertions(+), 1527 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/drv_types_linux.h

--
1.7.10.4

