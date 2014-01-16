Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaAPCDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:03:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10030 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752376AbaAPCD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:03:28 -0500
Message-Id: <20140116020325.821459069@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 Jan 2014 20:58:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 8/8] Linux 3.2.53-rt76-rc1
References: <20140116015824.201732155@goodmis.org>
Content-Disposition: inline; filename=0008-Linux-3.2.53-rt76-rc1.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rt76-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 54e7da6..bd9bb72 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt75
+-rt76-rc1
-- 
1.8.4.3


