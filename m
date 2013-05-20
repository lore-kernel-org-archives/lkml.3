Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3ETKx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3ETKx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Boyer <jwboyer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 095/115] if_cablemodem.h: Add parenthesis around ioctl macros
Date: Mon, 20 May 2013 11:51:35 +0100
Message-Id: <1369047116-9378-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 4f924b2aa4d3cb30f07e57d6b608838edcbc0d88 upstream.

Protect the SIOCGCM* ioctl macros with parenthesis.

Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/if_cablemodem.h | 12 ++++++------
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
1.8.1.2

