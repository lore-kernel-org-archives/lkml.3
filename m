Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaEGNDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:03:40 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:56662 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaEGNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:03:38 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: robh+dt@kernel.org
Cc: devicetree@vger.kernel.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [RFC/PATCH 0/3] add adp5589 dt support
Date: Wed,  7 May 2014 10:00:41 -0300
Message-Id: <1399467644-27222-1-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 2.0.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables adp5589 keypad configuration via dt. Until now,
this was only done via platform data.

The adp5589 has many functions besides matrix keypad decoding. For now,
we only support keypad related functionality: including scan time and
pull resistors configuration.

  Patch 1 adds the functionality to the driver. There is a minor change
in old code to properly detect the device type if we're using DT.

  Patch 2 adds a DT include file to specify the chip lines for the pull
configuration with symbolic names.

  Patch 3 adds the binding documentation

Guido Martínez (3):
  drivers: input: keyboard: adp5589: add DT support
  DT: input: adp5589: add adp5589 include file
  DT: input: adp5589: add binding documentation

 .../devicetree/bindings/input/adp5589.txt          |  63 +++++++
 drivers/input/keyboard/adp5589-keys.c              | 207 ++++++++++++++++++++-
 include/dt-bindings/input/adp5589.h                |   7 +
 3 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/input/adp5589.txt
 create mode 100644 include/dt-bindings/input/adp5589.h

-- 
2.0.0.rc0

