Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaHRSj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:39:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37433 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:39:28 -0400
From: Andy Gross <agross@codeaurora.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, arm@kernel.org,
        Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>
Subject: [PATCH] MAINTAINERS: Add entry for SOC Qualcomm drivers
Date: Mon, 18 Aug 2014 13:38:51 -0500
Message-Id: <1408387131-32152-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a MAINTAINERS entry for the SOC Qualcomm drivers.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa948..3ad0a26 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8426,6 +8426,14 @@ F:	include/media/soc*
 F:	drivers/media/i2c/soc_camera/
 F:	drivers/media/platform/soc_camera/
 
+SOC/QUALCOMM DRIVERS
+M:	Andy Gross <agross@codeaurora.org>
+L:	linux-arm-msm@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/soc/qcom
+T:	git git://codeaurora.org/quic/kernel/agross-msm.git
+
 SOEKRIS NET48XX LED SUPPORT
 M:	Chris Boot <bootc@bootc.net>
 S:	Maintained
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

