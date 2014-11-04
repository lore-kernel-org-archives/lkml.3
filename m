Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaKDTXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:23:17 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:31382 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbaKDTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:23:14 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4SACgnWVRbsl9p/2dsb2JhbABbgw6BLLp9BgEBAQEBBQF0miIEAoEkFwEBAQEBfYRfI4EaN4hFAb5rjwkshjeKWR2ENQWeB4x3iViBRwE2IIFbPC+BBiOBIgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipv4: add kernel parameter tcpmhash_entries
Date: Tue,  4 Nov 2014 20:23:08 +0100
Message-Id: <1415128988-11665-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/kernel-parameters.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4c81a86..5f37111 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3412,6 +3412,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			neutralize any effect of /proc/sys/kernel/sysrq.
 			Useful for debugging.
 
+	tcpmhash_entries=  [KNL,NET]
+			Set tcp_metrics_hash slot number.
+			Default value is 8192 or 16384 depending on total
+			ram pages.
+
 	tdfx=		[HW,DRM]
 
 	test_suspend=	[SUSPEND][,N]
-- 
1.9.3

