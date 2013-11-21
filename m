Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3KUSnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:43:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:39217 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755141Ab3KUSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:42:22 -0500
Message-Id: <20131121184218.677962353@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 13:42:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 5/5] Linux 3.4.69-rt86-rc1
References: <20131121184159.676777537@goodmis.org>
Content-Disposition: inline; filename=0005-Linux-3.4.69-rt86-rc1.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.69-rt86-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 168858f..29dd2e2 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt85
+-rt86-rc1
-- 
1.8.4.rc3


