Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3IHM4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3IHM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:56:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=TD0EPTe9uIQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6vidgQ2l4MoA:10 a=WcQw1p1tIgrU-G_rG6gA:9 a=jeBq3FmKZ4MA:10 a=XzP_FcdOR4kA:10 a=SA2qyKo5q2UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908122701.330939318@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 08:25:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 10/10] Linux 3.8.13-rt16-rc1
References: <20130908122545.421180629@goodmis.org>
Content-Disposition: inline; filename=0010-Linux-3.8.13-rt16-rc1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 18777ec..5d3eaf3 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt15
+-rt16-rc1
-- 
1.7.10.4


