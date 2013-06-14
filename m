Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3FNFXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:51 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:59033 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3FNFXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:49 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 0/9] mfd: 88pm80x: bug fixes and enhancement
Date: Fri, 14 Jun 2013 01:21:44 -0400
Message-ID: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set fixes some bugs in the 88pm800/88pm805 driver, and it add
regulator device into 88pm800.

The patches are tested based on Marvell pxa988 platform.

V2->V1:
  add more fixes patches.
  Below patches are same almost same as V1
     mfd: 88pm800: fix NULL pointer errorm
     mfd: 88pm800/88pm805: remove "IRQF_TRIGGER_FALLING" flag
  Other patches are new.

Chao Xie (7):
  mfd: 88pm80x: fix driver name for 88pm800 and 88pm805
  mfd: 88pm800: fix for mask_invert
  mfd: 88pm800: remove the power and gpadc page addr from platform data
  mfd: 88pm800: fixes error handling for sub pages probe/remove
  mfd: 88pm80x: Changes chip id definition and detection
  mfd: 88pm800: enhance sub devices initialization
  mfd: 88pm800: add regulator sub device

Yi Zhang (2):
  mfd: 88pm800: fix NULL pointer error
  mfd: 88pm800/88pm805: remove "IRQF_TRIGGER_FALLING" flag

 drivers/mfd/88pm800.c       |  237 +++++++++++++++++++++++++------------------
 drivers/mfd/88pm805.c       |   20 +---
 drivers/mfd/88pm80x.c       |   47 +++++++--
 include/linux/mfd/88pm80x.h |   17 ++--
 4 files changed, 193 insertions(+), 128 deletions(-)

-- 
1.7.4.1

