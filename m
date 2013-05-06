Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab3EFDEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:04:53 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:36445 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab3EFDEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:04:51 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 0/5] input: pxa27x-keypad: enhancement and device tree support
Date: Sun, 5 May 2013 23:04:03 -0400
Message-ID: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches include 2 parts
1. use matrix_keypad for matrix keyes support
2. add device tree support for pxa27x-keypad

V2->V1:
Do not copy the members from pdata. For device tree support,
directly allocate the pdata structure.

Chao Xie (5):
  input: pxa27x-keypad: use matrix_keymap for matrix keyes
  arm: mmp: use matrix_keymap for aspenite
  arm: mmp: use matrix_keymap for teton_bga
  input: pxa27x-keypad: remove the unused members at platform data
  input: pxa27x-keypad: add device tree support

 .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 +++++
 arch/arm/mach-mmp/aspenite.c                       |   10 +-
 arch/arm/mach-mmp/teton_bga.c                      |    8 +-
 drivers/input/keyboard/Kconfig                     |    1 +
 drivers/input/keyboard/pxa27x_keypad.c             |  266 ++++++++++++++++++--
 include/linux/platform_data/keypad-pxa27x.h        |    3 +-
 6 files changed, 325 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/pxa27x-keypad.txt

-- 
1.7.4.1

