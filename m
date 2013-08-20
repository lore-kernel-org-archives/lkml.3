Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab3HTGWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:22:33 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44286 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3HTGWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:22:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7K6IvaU020171, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 0/6] MFD patches for Realtek cardreader
Date: Tue, 20 Aug 2013 14:18:50 +0800
Message-ID: <cover.1376978825.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

v3:
Seperate copyright changes to a distinct patch
Modify some coding style and naming style
Fix a bug that sd30_drive_sel would be assigned a wrong value, in rts5227 and rts5249

v2:
Use macro when initializing vendor settings

Wei WANG (6):
  mfd:rtsx: Read vendor setting from config space
  mfd:rtsx: Add shutdown callback in rtsx_pci_driver
  mfd:rtsx: Move some actions from rtsx_pci_init_hw to individual
    extra_init_hw
  mfd:rtsx: Clear hardware PFM mode in rtl8411b
  mfd:rtsx: Configure to enter a deeper power-saving mode in S3
  mfd:rtsx: Modify copyright comments

 drivers/mfd/rtl8411.c           |   90 ++++++++++++++++++++++++++++---
 drivers/mfd/rts5209.c           |   61 +++++++++++++++------
 drivers/mfd/rts5227.c           |  113 ++++++++++++++++++++++++++++++---------
 drivers/mfd/rts5229.c           |   51 ++++++++++++++++--
 drivers/mfd/rts5249.c           |  108 +++++++++++++++++++++++++++++--------
 drivers/mfd/rtsx_pcr.c          |   76 +++++++++++++++++++-------
 drivers/mfd/rtsx_pcr.h          |   32 ++++++++++-
 include/linux/mfd/rtsx_common.h |    3 +-
 include/linux/mfd/rtsx_pci.h    |   51 ++++++++++++++++--
 9 files changed, 482 insertions(+), 103 deletions(-)

-- 
1.7.9.5

