Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab3E1D4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758829Ab3E1DyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Paul Wouters" <pwouters@redhat.com>,
        "Josh Boyer" <jwboyer@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.506617286@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [87/94] if_cablemodem.h: Add parenthesis around ioctl macros
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

[ Upstream commit 4f924b2aa4d3cb30f07e57d6b608838edcbc0d88 ]

Protect the SIOCGCM* ioctl macros with parenthesis.

Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

