Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab3DKCoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:44:00 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53703 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934841Ab3DKCn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:43:58 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r3B2hfWm005901, This message is released by code: ctlocs8528
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2] Add new model: rts5249
Date: Thu, 11 Apr 2013 10:43:39 +0800
Message-ID: <cover.1365648007.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

v2:
1. Modify copyright notice
2. Add macro definitions for phy registers
3. Replace mdelay with msleep

Wei WANG (1):
  mfd:rtsx: Support RTS5249

 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/rts5249.c        |  241 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.c       |    5 +
 drivers/mfd/rtsx_pcr.h       |    1 +
 include/linux/mfd/rtsx_pci.h |   36 +++++++
 5 files changed, 284 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mfd/rts5249.c

-- 
1.7.9.5

