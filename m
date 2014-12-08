Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaLHPIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:08:04 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:64223 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaLHPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:08:01 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/4] Add support for PCI mapped devices and rmmod
Date: Mon,  8 Dec 2014 16:07:52 +0100
Message-Id: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patchset is to use the driver on a PCI mapped fpga.

This patchset also converts the driver to platform device, so it will support
hot plugged devices and rmmod.

Ricardo Ribalda Delgado (4):
  gpio/xilinx: remove offset property
  gpio/xilinx: Convert the driver to platform device interface
  gpio-xilinx: Implement remove callback
  gpio-xilinx: Add support for X86 Arch

 drivers/gpio/Kconfig       |   4 +-
 drivers/gpio/gpio-xilinx.c | 114 ++++++++++++++++++++++++++++-----------------
 2 files changed, 73 insertions(+), 45 deletions(-)

-- 
2.1.3

