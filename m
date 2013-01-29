Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3A2HV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:21:57 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33762 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3A2HVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:21:47 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0T7Lbur004026
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 1/6] MFD:rtsx: Fix typo in comment
Date: Tue, 29 Jan 2013 15:21:32 +0800
Message-ID: <31283b661dd94537ff438f039df321d17f2fde03.1359443488.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359443487.git.wei_wang@realsil.com.cn>
References: <cover.1359443487.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Fix a misspelling word in comment

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 include/linux/mfd/rtsx_pci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 4b117a3..3f2bf26 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -465,7 +465,7 @@
 #define	SD_RSP_TYPE_R6			0x01
 #define	SD_RSP_TYPE_R7			0x01
 
-/* SD_CONFIURE3 */
+/* SD_CONFIGURE3 */
 #define	SD_RSP_80CLK_TIMEOUT_EN		0x01
 
 /* Card Transfer Reset Register */
-- 
1.7.9.5

