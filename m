Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3DYHCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:02:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3DYHCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:02:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,548,1363104000"; 
   d="scan'208";a="7136131"
From: liguang <lig.fnst@cn.fujitsu.com>
To: Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] drivers: idle: comment DEBUG
Date: Thu, 25 Apr 2013 15:00:27 +0800
Message-Id: <1366873227-920-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/25 15:01:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/25 15:01:03,
	Serialize complete at 2013/04/25 15:01:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems we should comment DEBUG as above comment said:
"/* un-comment DEBUG to enable pr_debug() statements */"

now, pr_debug is already enabled as DEBUG been defined.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d66750..9618586 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -51,7 +51,7 @@
  */
 
 /* un-comment DEBUG to enable pr_debug() statements */
-#define DEBUG
+/* #define DEBUG */
 
 #include <linux/kernel.h>
 #include <linux/cpuidle.h>
-- 
1.7.2.5

