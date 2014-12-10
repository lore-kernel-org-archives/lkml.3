Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbaLJPZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:25:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48116 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940AbaLJPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:25:05 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 0/4] gpio/xilinx: Add support for PCI mapped devices and rmmod
Date: Wed, 10 Dec 2014 16:24:56 +0100
Message-Id: <1418225100-2949-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patchset is to use the driver on a PCI mapped fpga.

This patchset also converts the driver to platform device, so it will support
hot plugged devices and rmmod.

Changeset:

v3
Suggested by Michal Simek <michal.simek@xilinx.com>
-Add patch for fixing kernel-doc
-Leave the driver at subsys_initcall


v2
Suggested by Alexandre Courbot <gnurou@gmail.com>
Merge 2 and 3 (convert to platform device and implement remove)


Ricardo Ribalda Delgado (4):
  gpio/xilinx: Remove offset property
  gpio/xilinx: Convert the driver to platform device interface
  gpio/xilinx: Add support for X86 Arch
  gpio/xilinx: Fix kernel-doc

 drivers/gpio/Kconfig       |   4 +-
 drivers/gpio/gpio-xilinx.c | 148 ++++++++++++++++++++++++++++-----------------
 2 files changed, 94 insertions(+), 58 deletions(-)

-- 
2.1.3

