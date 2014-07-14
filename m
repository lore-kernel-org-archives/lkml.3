Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbaGNUFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:05:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:40322 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757095AbaGNUEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:04:37 -0400
Message-Id: <20140714200435.975422446@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 16:04:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 3/3] Linux 3.10.47-rt50-rc1
References: <20140714200420.805309842@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-Linux-3.10.47-rt50-rc1.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.47-rt50-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 4b7dca68a5b4..e8a9a36bb066 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt49
+-rt50-rc1
-- 
2.0.0


