Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3GOHHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:07:52 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49471 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3GOHHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:07:51 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 03:07:51 EDT
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6F6uFsG017570, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <adam.lee@canonical.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 0/5] mfd:rtsx: MFD patches for Realtek cardreader
Date: Mon, 15 Jul 2013 14:56:09 +0800
Message-ID: <cover.1373871135.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Wei WANG (5):
  mfd:rtsx: Read vendor setting from config space
  mfd:rtsx: Add shutdown callback in rtsx_pci_driver
  mfd:rtsx: Move some actions from rtsx_pci_init_hw to individual
    extra_init_hw
  mfd:rtsx: Clear hardware PFM mode in rtl8411b
  mfd:rtsx: Configure to enter a deeper power-saving mode in S3

 drivers/mfd/rtl8411.c           |   86 ++++++++++++++++++++++++++---
 drivers/mfd/rts5209.c           |   55 +++++++++++++------
 drivers/mfd/rts5227.c           |  113 ++++++++++++++++++++++++++++++---------
 drivers/mfd/rts5229.c           |   49 +++++++++++++++--
 drivers/mfd/rts5249.c           |  108 +++++++++++++++++++++++++++++--------
 drivers/mfd/rtsx_pcr.c          |   76 +++++++++++++++++++-------
 drivers/mfd/rtsx_pcr.h          |   15 +++++-
 include/linux/mfd/rtsx_common.h |    3 +-
 include/linux/mfd/rtsx_pci.h    |   35 ++++++++++--
 9 files changed, 439 insertions(+), 101 deletions(-)

-- 
1.7.9.5

