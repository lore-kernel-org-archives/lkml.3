Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3GQIKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:10:20 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57848 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3GQIKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:10:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6H89vgA029302, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2 0/5] mfd:rtsx: MFD patches for Realtek cardreader
Date: Wed, 17 Jul 2013 16:09:50 +0800
Message-ID: <cover.1373953200.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

v2:
Use macro when initializing vendor settings

Wei WANG (5):
  mfd:rtsx: Read vendor setting from config space
  mfd:rtsx: Add shutdown callback in rtsx_pci_driver
  mfd:rtsx: Move some actions from rtsx_pci_init_hw to individual
    extra_init_hw
  mfd:rtsx: Clear hardware PFM mode in rtl8411b
  mfd:rtsx: Configure to enter a deeper power-saving mode in S3

 drivers/mfd/rtl8411.c           |   90 +++++++++++++++++++++++++++---
 drivers/mfd/rts5209.c           |   61 +++++++++++++++------
 drivers/mfd/rts5227.c           |  115 +++++++++++++++++++++++++++++++--------
 drivers/mfd/rts5229.c           |   51 +++++++++++++++--
 drivers/mfd/rts5249.c           |  110 ++++++++++++++++++++++++++++++-------
 drivers/mfd/rtsx_pcr.c          |   76 +++++++++++++++++++-------
 drivers/mfd/rtsx_pcr.h          |   32 ++++++++++-
 include/linux/mfd/rtsx_common.h |    3 +-
 include/linux/mfd/rtsx_pci.h    |   35 ++++++++++--
 9 files changed, 470 insertions(+), 103 deletions(-)

-- 
1.7.9.5

