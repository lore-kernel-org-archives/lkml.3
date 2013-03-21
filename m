Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3CUXf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:35:28 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:51123 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab3CUXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:35:26 -0400
Message-ID: <1363908924.1390.164.camel@x61.thuisdomein>
Subject: [PATCH] appletalk: remove "config IPDDP_DECAP"
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Mar 2013 00:35:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 23:35:25.0064 (UTC) FILETIME=[C316A080:01CE268C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol IPDDP_DECAP got added in v2.1.75. It has never been
used. Its entry can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) No, v2.1.75 is not a typo.

1) A follow up patch might involve some corrections to the IPDDP and
IPDDP_ENCAP entries and to Documentation/networking/ipddp.txt. I hope to
do that within the next 16 years.

2) Untested, by the way.

 drivers/net/appletalk/Kconfig | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index f5a8916..4ce6ca5 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -106,20 +106,4 @@ config IPDDP_ENCAP
 	  IP packets inside AppleTalk frames; this is useful if your Linux box
 	  is stuck on an AppleTalk network (which hopefully contains a
 	  decapsulator somewhere). Please see
-	  <file:Documentation/networking/ipddp.txt> for more information. If
-	  you said Y to "AppleTalk-IP driver support" above and you say Y
-	  here, then you cannot say Y to "AppleTalk-IP to IP Decapsulation
-	  support", below.
-
-config IPDDP_DECAP
-	bool "Appletalk-IP to IP Decapsulation support"
-	depends on IPDDP
-	help
-	  If you say Y here, the AppleTalk-IP code will be able to decapsulate
-	  AppleTalk-IP frames to IP packets; this is useful if you want your
-	  Linux box to act as an Internet gateway for an AppleTalk network.
-	  Please see <file:Documentation/networking/ipddp.txt> for more
-	  information.  If you said Y to "AppleTalk-IP driver support" above
-	  and you say Y here, then you cannot say Y to "IP to AppleTalk-IP
-	  Encapsulation support", above.
-
+	  <file:Documentation/networking/ipddp.txt> for more information.
-- 
1.7.11.7

