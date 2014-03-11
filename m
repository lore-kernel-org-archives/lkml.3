Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaCKJY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:24:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbaCKJXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:23:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677986"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        openipmi-developer@lists.sourceforge.net,
        Corey Minyard <minyard@acm.org>
Subject: [PATCH 10/16] driver/char: Replace hardcoding of 19 with MAX_NICE.
Date: Tue, 11 Mar 2014 17:20:31 +0800
Message-Id: <c2743923807d7beba3992a4a2524a6cb99b885fd.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:17,
	Serialize complete at 2014/03/11 17:20:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: openipmi-developer@lists.sourceforge.net
cc: Corey Minyard <minyard@acm.org>
---
 drivers/char/ipmi/ipmi_si_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 03f4189..03c0eed 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -999,7 +999,7 @@ static int ipmi_thread(void *data)
 	struct timespec busy_until;
 
 	ipmi_si_set_not_busy(&busy_until);
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	while (!kthread_should_stop()) {
 		int busy_wait;
 
-- 
1.8.2.1

