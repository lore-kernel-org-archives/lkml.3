Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab3FCWQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:16:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3FCWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:23 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aiOeTVPvzSwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=g-7eFPA5RtsA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=x2c9d1rNqANMQ9gOkQ0A:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221159.158468098@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Wouters <pwouters@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [40/65] if_cablemodem.h: Add parenthesis around ioctl macros
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0040-if_cablemodem.h-Add-parenthesis-around-ioctl-macros.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

[ Upstream commit 4f924b2aa4d3cb30f07e57d6b608838edcbc0d88 ]

Protect the SIOCGCM* ioctl macros with parenthesis.

Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/if_cablemodem.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/if_cablemodem.h b/include/linux/if_cablemodem.h
index 9ca1007..ee6b3c4 100644
--- a/include/linux/if_cablemodem.h
+++ b/include/linux/if_cablemodem.h
@@ -12,11 +12,11 @@
  */
 
 /* some useful defines for sb1000.c e cmconfig.c - fv */
-#define SIOCGCMSTATS		SIOCDEVPRIVATE+0	/* get cable modem stats */
-#define SIOCGCMFIRMWARE		SIOCDEVPRIVATE+1	/* get cm firmware version */
-#define SIOCGCMFREQUENCY	SIOCDEVPRIVATE+2	/* get cable modem frequency */
-#define SIOCSCMFREQUENCY	SIOCDEVPRIVATE+3	/* set cable modem frequency */
-#define SIOCGCMPIDS			SIOCDEVPRIVATE+4	/* get cable modem PIDs */
-#define SIOCSCMPIDS			SIOCDEVPRIVATE+5	/* set cable modem PIDs */
+#define SIOCGCMSTATS		(SIOCDEVPRIVATE+0)	/* get cable modem stats */
+#define SIOCGCMFIRMWARE		(SIOCDEVPRIVATE+1)	/* get cm firmware version */
+#define SIOCGCMFREQUENCY	(SIOCDEVPRIVATE+2)	/* get cable modem frequency */
+#define SIOCSCMFREQUENCY	(SIOCDEVPRIVATE+3)	/* set cable modem frequency */
+#define SIOCGCMPIDS			(SIOCDEVPRIVATE+4)	/* get cable modem PIDs */
+#define SIOCSCMPIDS			(SIOCDEVPRIVATE+5)	/* set cable modem PIDs */
 
 #endif
-- 
1.7.10.4


