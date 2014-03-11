Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaCKFEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:04:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaCKFBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676440"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        openipmi-developer@lists.sourceforge.net,
        Corey Minyard <minyard@acm.org>
Subject: [PATCH 10/15] driver/char: Replace hardcoding of 19 with MAX_NICE.
Date: Tue, 11 Mar 2014 12:59:25 +0800
Message-Id: <4983af3d05a44fa157c6f3043704d231bc4cb7df.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:55,
	Serialize complete at 2014/03/11 12:58:55
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

