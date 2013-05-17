Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3EQVr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:47:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3EQVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Wouters <pwouters@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/50] if_cablemodem.h: Add parenthesis around ioctl macros
Date: Fri, 17 May 2013 14:47:10 -0700
Message-Id: <20130517213846.390307640@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Josh Boyer <jwboyer@redhat.com>

[ Upstream commit 4f924b2aa4d3cb30f07e57d6b608838edcbc0d88 ]

Protect the SIOCGCM* ioctl macros with parenthesis.

Reported-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/if_cablemodem.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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


