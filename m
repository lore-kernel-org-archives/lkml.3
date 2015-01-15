Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbbAOLTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:19:40 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50053 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbAOLTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:19:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0FBJ8IR002279, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 00/10] mfd: rtsx: add support for new rts524A and rts525A
Date: Thu, 15 Jan 2015 19:18:57 +0800
Message-ID: <cover.1421320541.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

This patchset including re-format some coding-style and add two new chip
rts524A and rts525A.

Micky Ching (10):
  mfd: rtsx: replace TAB by SPC after #define
  mfd: rtsx: place register address and values togather
  mfd: rtsx: add debug info when access register failed
  mfd: rtsx: update PETXCFG address
  mfd: rtsx: update driving settings
  mfd: rtsx: update phy register
  mfd: rtsx: remove LCTLR defination
  mfd: rtsx: add support for rts524A
  mfd: rtsx: add support for rts525A
  mfd: rtsx: using pcr_dbg replace dev_dbg

 drivers/mfd/Makefile         |   2 +-
 drivers/mfd/rtl8411.c        |  11 +-
 drivers/mfd/rts5209.c        |   4 +-
 drivers/mfd/rts5227.c        |  12 +-
 drivers/mfd/rts5229.c        |   4 +-
 drivers/mfd/rts5249.c        | 274 ++++++++++---
 drivers/mfd/rtsx_gops.c      |  37 --
 drivers/mfd/rtsx_pcr.c       | 114 ++++--
 drivers/mfd/rtsx_pcr.h       |   5 +
 include/linux/mfd/rtsx_pci.h | 950 +++++++++++++++++++++----------------------
 10 files changed, 778 insertions(+), 635 deletions(-)
 delete mode 100644 drivers/mfd/rtsx_gops.c

-- 
1.9.1

