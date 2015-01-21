Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbbAUPxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:53:21 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:38312 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbbAUPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:53:14 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/3] xilinx-spi: Support more spi modes and multiple device tree
Date: Wed, 21 Jan 2015 16:53:07 +0100
Message-Id: <1421855590-9210-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add drier support for hardware implemented modes:
spi_lsb_fist and spi_loop

Also fix an issue when multiple spi devices are defined on a device tree.

Ricardo Ribalda Delgado (3):
  spi/xilinx: Use automatic bus number on device tree
  spi/xilinx: Support for spi mode LSB_FIRST
  spi/xilinx: Support for spi mode LOOP

 drivers/spi/spi-xilinx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.1.4

