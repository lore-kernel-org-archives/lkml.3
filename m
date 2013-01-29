Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3A2HWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:22:00 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33761 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3A2HVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:21:47 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0T7Lbuq004026, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 0/6] MFD:rtsx: Fix coding style and optimize flow
Date: Tue, 29 Jan 2013 15:21:31 +0800
Message-ID: <cover.1359443487.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

This patchset fixes some coding style issues, and optimizes card detect
flow to improve the stability when inserting card.

Wei WANG (6):
  MFD:rtsx: Fix typo in comment
  MFD:rtsx: Remove redundant code
  MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
  MFD:rtsx: Fix checkpatch warning
  MFD:rtsx: Use macro defines to replace some variables
  MFD:rtsx: Optimize card detect flow

 drivers/mfd/rtsx_pcr.c       |   63 +++++++++++++++++++++++-------------------
 drivers/mfd/rtsx_pcr.h       |    3 ++
 include/linux/mfd/rtsx_pci.h |    2 +-
 3 files changed, 38 insertions(+), 30 deletions(-)

-- 
1.7.9.5

