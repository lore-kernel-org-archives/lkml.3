Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3GTGVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 02:21:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35519 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3GTGVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 02:21:22 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 0/2] adv7343 add OF support
Date: Sat, 20 Jul 2013 11:51:04 +0530
Message-Id: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This series adds OF support for adv7343 driver.
The first patch makes platform data members as a array,
so to ease in adding DT support.

Lad, Prabhakar (2):
  media: i2c: adv7343: make the platform data members as array
  media: i2c: adv7343: add OF support

 .../devicetree/bindings/media/i2c/adv7343.txt      |   48 +++++++++++++
 arch/arm/mach-davinci/board-da850-evm.c            |    6 +-
 drivers/media/i2c/adv7343.c                        |   74 ++++++++++++++++----
 include/media/adv7343.h                            |   20 ++----
 4 files changed, 113 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt

-- 
1.7.9.5

