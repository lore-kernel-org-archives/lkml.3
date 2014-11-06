Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaKFSrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:47:02 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:33987 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbaKFSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:46:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwNAMrAW1RbsGyn/2dsb2JhbABbgw6BLbdbCwUBdJoTgSIXAQEBAQF9hF8jgRo3iEUBwBePQiyGOIpZHYQ1BZ4UgTKLS4IphzOBRwE2IIFbPC+BBiOBIgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Fabian Frederick <fabf@skynet.be>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH V2 linux-next] ipv4: add kernel parameter tcpmhash_entries
Date: Thu,  6 Nov 2014 19:46:50 +0100
Message-Id: <1415299611-5373-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also adds a reference to ip-sysctl.txt
where TCP metrics setup is described

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: Add a reference to ip-sysctl and update description.
(suggested by Jonathan Corbet).

 Documentation/kernel-parameters.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 3c5a178..e8b25d0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3434,6 +3434,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			neutralize any effect of /proc/sys/kernel/sysrq.
 			Useful for debugging.
 
+	tcpmhash_entries= [KNL,NET]
+			Set the number of tcp_metrics_hash slots.
+			Default value is 8192 or 16384 depending on total
+			ram pages. This is used to specify the TCP metrics
+			cache size. See Documentation/networking/ip-sysctl.txt
+			"tcp_no_metrics_save" section for more details.
+
 	tdfx=		[HW,DRM]
 
 	test_suspend=	[SUSPEND][,N]
-- 
1.9.1

