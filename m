Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaFQHQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:16:02 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52259 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaFQHQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:16:00 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v1 0/3] Driver for TI CC2520 radio
Date: Tue, 17 Jun 2014 12:44:55 +0530
Message-Id: <1402989298-8898-1-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 This patch series adds the driver support for TI cc2520 radio and also
adds the device tree bindings for cc2520 driver.

changes:
	- Improvements in the locking mechanism in Tx and SFD ISR.
	- Proper checkings for GPIO pins.
	- avoids the memory leak for priv.
	- used devm_* APIs.
	- moved the code from header file to .c file
	- removed cc2520_unregister()

Varka Bhadram (3):
  ieee802154: cc2520: adds driver for TI CC2520 radio
  ieee802154: cc2520: add driver to kernel build system
  devicetree: add device tree bindings for cc2520 driver

 .../devicetree/bindings/net/ieee802154/cc2520.txt  |   26 +
 drivers/net/ieee802154/Kconfig                     |   11 +
 drivers/net/ieee802154/Makefile                    |    1 +
 drivers/net/ieee802154/cc2520.c                    |  966 ++++++++++++++++++++
 include/linux/spi/cc2520.h                         |   26 +
 5 files changed, 1030 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 create mode 100644 drivers/net/ieee802154/cc2520.c
 create mode 100644 include/linux/spi/cc2520.h

-- 
1.7.9.5

