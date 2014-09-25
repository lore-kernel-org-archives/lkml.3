Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaIYFXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:23:45 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53512 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:23:43 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, dmitry.torokhov@gmail.com, zonque@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v3 0/3] cap1106: add support for cap11xx variants
Date: Wed, 24 Sep 2014 22:24:19 -0700
Message-Id: <1411622662-16581-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:

 * Rename apply relevant CAP1106 references to CAP11XX to make generic
   for variant support

Matt Ranostay (3):
  cap11xx: make driver generic for variant support
  cap11xx: Add support for various cap11xx devices
  cap11xx: support for irq-active-high option

 .../devicetree/bindings/input/cap1106.txt          |  53 ---
 .../devicetree/bindings/input/cap11xx.txt          |  59 ++++
 drivers/input/keyboard/Kconfig                     |   8 +-
 drivers/input/keyboard/Makefile                    |   2 +-
 drivers/input/keyboard/cap1106.c                   | 341 -------------------
 drivers/input/keyboard/cap11xx.c                   | 372 +++++++++++++++++++++
 6 files changed, 436 insertions(+), 399 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/input/cap1106.txt
 create mode 100644 Documentation/devicetree/bindings/input/cap11xx.txt
 delete mode 100644 drivers/input/keyboard/cap1106.c
 create mode 100644 drivers/input/keyboard/cap11xx.c

-- 
1.9.1

