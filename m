Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab3CLSq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:46:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34179 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab3CLSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:42:04 -0400
X-IronPort-AV: E=Sophos;i="4.84,832,1355126400"; 
   d="scan'208";a="28850329"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 02/11] fix: Use EXPORT_SYMBOL_GPL
Date: Tue, 12 Mar 2013 11:41:47 -0700
Message-Id: <1363113716-25897-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/ssbi/ssbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssbi/ssbi.c b/drivers/ssbi/ssbi.c
index 8b0b10d..c08a7b8 100644
--- a/drivers/ssbi/ssbi.c
+++ b/drivers/ssbi/ssbi.c
@@ -242,7 +242,7 @@ int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
 
 	return ret;
 }
-EXPORT_SYMBOL(msm_ssbi_read);
+EXPORT_SYMBOL_GPL(msm_ssbi_read);
 
 int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
 {
@@ -259,7 +259,7 @@ int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
 
 	return ret;
 }
-EXPORT_SYMBOL(msm_ssbi_write);
+EXPORT_SYMBOL_GPL(msm_ssbi_write);
 
 static int msm_ssbi_add_slave(struct msm_ssbi *ssbi,
 				const struct msm_ssbi_slave_info *slave)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

