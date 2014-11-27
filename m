Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaK0DEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:04:49 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:39953 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaK0DEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:04:48 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAR347VN010490, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 0/2] mmc: rtsx: add support for sdio card
Date: Thu, 27 Nov 2014 10:53:57 +0800
Message-ID: <cover.1417056337.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

This patch is used to change transfer mode for sdio card support
by SD interface.

Micky Ching (2):
  mfd: rtsx: add func to split u32 into register
  mmc: rtsx: add support for sdio card

 drivers/mmc/host/rtsx_pci_sdmmc.c | 366 ++++++++++++++++++++++----------------
 include/linux/mfd/rtsx_pci.h      |  15 ++
 2 files changed, 224 insertions(+), 157 deletions(-)

-- 
1.9.1

