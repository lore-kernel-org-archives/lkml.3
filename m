Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3BFWDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:03:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28700 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3BFWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:02:52 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gSy9wxulgeIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6vidgQ2l4MoA:10 a=20KFwNOVAAAA:8 a=-tQZ3a5CFpzxEfrFyO4A:9 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130206220251.589230834@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Feb 2013 17:02:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 6/6] Linux 3.2.38-rt57-rc1
References: <20130206220210.823160521@goodmis.org>
Content-Disposition: inline; filename=0006-Linux-3.2.38-rt57-rc1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index fdb0f88..c12fc9d 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt56
+-rt57-rc1
-- 
1.7.10.4


