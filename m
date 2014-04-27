Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaD0Ofq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:35:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:29793 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752654AbaD0Oex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:34:53 -0400
Message-Id: <20140427143451.953860878@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 27 Apr 2014 10:34:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 3/3] Linux 3.8.13.14-rt31-rc1
References: <20140427143430.589333461@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-Linux-3.8.13.14-rt31-rc1.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14-rt31-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index b72862e..7f30ff7 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt30
+-rt31-rc1
-- 
1.8.5.3


