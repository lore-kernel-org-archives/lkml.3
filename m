Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3EMV6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:58:21 -0400
Received: from longford.logfs.org ([213.229.74.203]:59169 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3EMV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:58:20 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 1/3] target: removed unused transport_state flag
Date: Mon, 13 May 2013 16:30:05 -0400
Message-Id: <1368477007-25274-2-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368477007-25274-1-git-send-email-joern@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joern Engel <joern@logfs.org>
---
 include/target/target_core_base.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4af592..068ec0f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -463,7 +463,6 @@ struct se_cmd {
 #define CMD_T_ABORTED		(1 << 0)
 #define CMD_T_ACTIVE		(1 << 1)
 #define CMD_T_COMPLETE		(1 << 2)
-#define CMD_T_QUEUED		(1 << 3)
 #define CMD_T_SENT		(1 << 4)
 #define CMD_T_STOP		(1 << 5)
 #define CMD_T_FAILED		(1 << 6)
-- 
1.7.10.4

