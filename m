Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3LKAi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:38:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64867 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751467Ab3LKAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:38:06 -0500
Message-Id: <20131211003802.275358335@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Dec 2013 19:37:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 5/5] Linux 3.10.22-rt20-rc1
References: <20131211003732.351606520@goodmis.org>
Content-Disposition: inline; filename=0005-Linux-3.10.22-rt20-rc1.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.22-rt20-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 483ad77..5361419 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt19
+-rt20-rc1
-- 
1.8.4.3


