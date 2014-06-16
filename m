Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaFPExA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:53:00 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43059 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaFPEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:52:58 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next 0/3] Driver for TI CC2520 Radio chip
Date: Mon, 16 Jun 2014 10:21:55 +0530
Message-Id: <1402894318-30349-1-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds the support for cc2520 radio and
provides device tree bindings for cc2520

Varka Bhadram (3):
  ieee802154: cc2520: driver for TI cc2520 radio
  ieee802154: cc2520: add driver to kernel build system
  devicetree: add devicetree bindings for cc2520 driver

 .../devicetree/bindings/net/ieee802154/cc2520.txt  |   26 +
 drivers/net/ieee802154/Kconfig                     |   11 +
 drivers/net/ieee802154/Makefile                    |    1 +
 drivers/net/ieee802154/cc2520.c                    |  805 ++++++++++++++++++++
 include/linux/spi/cc2520.h                         |  176 +++++
 5 files changed, 1019 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 create mode 100644 drivers/net/ieee802154/cc2520.c
 create mode 100644 include/linux/spi/cc2520.h

-- 
1.7.9.5

