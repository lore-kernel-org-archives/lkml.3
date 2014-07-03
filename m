Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaGCBeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:34:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59142 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751535AbaGCBeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:34:22 -0400
Message-Id: <20140703013419.587545468@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 02 Jul 2014 21:34:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 2/2] Linux 3.4.94-rt117-rc1
References: <20140703013409.809031176@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-Linux-3.4.94-rt117-rc1.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.94-rt117-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 34eca4e89203..d5f654342ac4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt116
+-rt117-rc1
-- 
2.0.0


