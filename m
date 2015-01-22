Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbAVEkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:40:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55164 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbbAVEjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:39:52 -0500
From: Andy Gross <agross@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH] MAINTAINERS: update Qualcomm support entry
Date: Wed, 21 Jan 2015 22:39:24 -0600
Message-Id: <1421901564-8854-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added myself as a co-maintainer.  Updated the files to include the Qualcomm SoC
directory.  Added linux-soc mailing list.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93409ad..2af6e23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1284,9 +1284,12 @@ S:	Maintained
 ARM/QUALCOMM SUPPORT
 M:	Kumar Gala <galak@codeaurora.org>
 M:	David Brown <davidb@codeaurora.org>
+M:	Andy Gross <agross@codeaurora.org>
 L:	linux-arm-msm@vger.kernel.org
+L:	linux-soc@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-qcom/
+F:	drivers/soc/qcom
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
-- 
Qualcomm Innovation Center, Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

