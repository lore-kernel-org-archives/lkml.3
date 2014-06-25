Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaFYIpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:45:07 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:65269 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563AbaFYIpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:45:01 -0400
Message-ID: <1403685898.1960.37.camel@x220>
Subject: [PATCH] Documentation: IB: Change 'CONFIG_INFINIBAND_USER_VERBS'
From: Paul Bolle <pebolle@tiscali.nl>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 10:44:58 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2014 08:44:58.0521 (UTC) FILETIME=[BED1E090:01CF9051]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INFINIBAND_USER_VERBS was changed to INFINIBAND_USER_ACCESS in commit
17781cd6186c ("[PATCH] IB: clean up user access config options"). Nine
years later it's time to change the documentation too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/infiniband/user_verbs.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/infiniband/user_verbs.txt
index e5092d696da2..621f5c377df9 100644
--- a/Documentation/infiniband/user_verbs.txt
+++ b/Documentation/infiniband/user_verbs.txt
@@ -1,6 +1,6 @@
 USERSPACE VERBS ACCESS
 
-  The ib_uverbs module, built by enabling CONFIG_INFINIBAND_USER_VERBS,
+  The ib_uverbs module, built by enabling CONFIG_INFINIBAND_USER_ACCESS,
   enables direct userspace access to IB hardware via "verbs," as
   described in chapter 11 of the InfiniBand Architecture Specification.
 
-- 
1.9.3

