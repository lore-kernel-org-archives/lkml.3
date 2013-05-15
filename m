Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab3EOL5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:57:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41669 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3EOL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:57:51 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/6] media: i2c: ths7303 feature enhancement and cleanup
Date: Wed, 15 May 2013 17:27:16 +0530
Message-Id: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series enables the ths7303 driver for asynchronous probing, OF
support with some cleanup patches.

Lad, Prabhakar (6):
  media: i2c: ths7303: remove init_enable option from pdata
  ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
  media: i2c: ths7303: remove unnecessary function ths7303_setup()
  media: i2c: ths7303: make the pdata as a constant pointer
  media: i2c: ths7303: add support for asynchronous probing
  media: i2c: ths7303: add OF support

 .../devicetree/bindings/media/i2c/ths73x3.txt      |   50 +++++++++++++
 arch/arm/mach-davinci/board-dm365-evm.c            |    1 -
 drivers/media/i2c/ths7303.c                        |   78 ++++++++++++-------
 include/media/ths7303.h                            |    2 -
 4 files changed, 99 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths73x3.txt

-- 
1.7.4.1

