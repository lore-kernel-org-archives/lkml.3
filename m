Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3FPVjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:39:13 -0400
Received: from etezian.org ([198.101.225.253]:40791 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab3FPVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:39:12 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org, rob@landley.net
Cc: oatilla@gmail.com, szsolt@gmail.com, linux-kernel@vger.kernel.org,
        andi@etezian.org, linux-doc@vger.kernel.org
Subject: [PATCH 0/2] etzkx accelerometer support
Date: Sun, 16 Jun 2013 23:40:26 +0200
Message-Id: <cover.1371418586.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

these two patches provide the etzkx device driver which supports
the following accelerometers:

 - Kionix kxcnl
 - Kionix kxtnk
 - ST lisn3dsh

Support for ST lis3dsh accelerometer is still in progress.

The etzkx accelerometers are a kind of devices that are able to
do gesture recognition directly on the device. It uses two slots
of 16 steps (bytes) each for loading algorithms which perform
gesture recognition.

The second patch contains the documentation of the device driver.

On http://www.etezian.org/etzkx/etzkx/ is possible to find more
informations about the accelerometer.

Thanks,
Andi

Andi Shyti (2):
  drivers/misc: etzkx driver for kxcnl/kxtnk accelerometer
  Documentation: added etzkx driver documentation

 Documentation/misc-devices/etzkx.txt |  325 +++++
 drivers/misc/Kconfig                 |   12 +
 drivers/misc/Makefile                |    1 +
 drivers/misc/etzkx.c                 | 2313 ++++++++++++++++++++++++++++++++++
 include/linux/i2c/etzkx.h            |  157 +++
 5 files changed, 2808 insertions(+)
 create mode 100644 Documentation/misc-devices/etzkx.txt
 create mode 100644 drivers/misc/etzkx.c
 create mode 100644 include/linux/i2c/etzkx.h

-- 
1.7.10.4

