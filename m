Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779AbaFRFRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:17:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42280 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbaFRFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:17:07 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v2 0/3] Driver fir TI CC2520 Radio
Date: Wed, 18 Jun 2014 10:46:02 +0530
Message-Id: <1403068565-32224-1-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the driver support for TI cc2520 radio.
also devicetree bindings for the driver.

changes since v1:
	- improverment in gpio setup
	- changed len pointer to len variable
	- 
Varka Bhadram (3):
  ieee802154: cc2520: adds driver for TI CC2520 radio
  ieee802154: cc2520: add driver to kernel build system
  devicetree: add devicetree bindings for cc2520 driver

 .../devicetree/bindings/net/ieee802154/cc2520.txt  |   26 +
 drivers/net/ieee802154/Kconfig                     |   11 +
 drivers/net/ieee802154/Makefile                    |    1 +
 drivers/net/ieee802154/cc2520.c                    |  968 ++++++++++++++++++++
 include/linux/spi/cc2520.h                         |   26 +
 5 files changed, 1032 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 create mode 100644 drivers/net/ieee802154/cc2520.c
 create mode 100644 include/linux/spi/cc2520.h

-- 
1.7.9.5

