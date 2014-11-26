Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaKZWrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:47:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36495 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaKZWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:47:16 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH] spmi: Remove shutdown/suspend/resume kernel-doc
Date: Wed, 26 Nov 2014 14:47:09 -0800
Message-Id: <1417042029-11227-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These members of the driver structure are not present.
Remove them from the kernel-doc.

Cc: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/spmi.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/spmi.h b/include/linux/spmi.h
index 91f5eab9e428..f84212cd3b7d 100644
--- a/include/linux/spmi.h
+++ b/include/linux/spmi.h
@@ -134,9 +134,6 @@ void spmi_controller_remove(struct spmi_controller *ctrl);
  *		this structure.
  * @probe:	binds this driver to a SPMI device.
  * @remove:	unbinds this driver from the SPMI device.
- * @shutdown:	standard shutdown callback used during powerdown/halt.
- * @suspend:	standard suspend callback used during system suspend.
- * @resume:	standard resume callback used during system resume.
  *
  * If PM runtime support is desired for a slave, a device driver can call
  * pm_runtime_put() from their probe() routine (and a balancing
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

