Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3E1VgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:36:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3E1VY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Boyer <jwboyer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 72/78] if_cablemodem.h: Add parenthesis around ioctl macros
Date: Tue, 28 May 2013 14:20:21 -0700
Message-Id: <1369776027-17859-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

[ Upstream commit 4f924b2aa4d3cb30f07e57d6b608838edcbc0d88 ]

Protect the SIOCGCM* ioctl macros with parenthesis.

Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/if_cablemodem.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/if_cablemodem.h b/include/uapi/linux/if_cablemodem.h
index 9ca1007..ee6b3c4 100644
--- a/include/uapi/linux/if_cablemodem.h
+++ b/include/uapi/linux/if_cablemodem.h
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

