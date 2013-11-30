Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3K3P0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:26:22 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51508 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3K3P0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:26:19 -0500
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 0/2] Add EOC handling for bmp085 + DT update
Date: Sat, 30 Nov 2013 16:25:59 +0100
Message-Id: <1385825161-5194-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add support for using EOC gpio line of bmp085 to detect when conversion
is finished. First patch add that functionality. Second patch document DT binding.

Changes from v1:
- drop custom platform data and use i2c, spi client irq
- use managed resources irq request
- document DT property
- drop patch 3 (adding platform data isn't necessary)

Marek Belisko (2):
  misc: bmp085: Clean up and enable use of interrupt for completion.
  misc: bmp085: devicetree irq update.

 Documentation/devicetree/bindings/misc/bmp085.txt |  4 +++
 drivers/misc/bmp085-i2c.c                         |  2 +-
 drivers/misc/bmp085-spi.c                         |  2 +-
 drivers/misc/bmp085.c                             | 39 ++++++++++++++++++++---
 drivers/misc/bmp085.h                             |  2 +-
 5 files changed, 41 insertions(+), 8 deletions(-)

-- 
1.8.3.2

