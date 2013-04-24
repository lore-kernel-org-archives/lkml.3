Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3DXOQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:16:33 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44988
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab3DXOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:16:24 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/7] Tools: hv: Fix a checkpatch warning
Date: Wed, 24 Apr 2013 07:48:50 -0700
Message-Id: <1366814934-4461-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366814934-4461-1-git-send-email-kys@microsoft.com>
References: <1366814913-4422-1-git-send-email-kys@microsoft.com>
 <1366814934-4461-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a checkpatch warning.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index dc3eb1e..921c1be 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -194,8 +194,9 @@ int main(void)
 		}
 
 		if (addr.nl_pid) {
-			syslog(LOG_WARNING, "Received packet from untrusted pid:%u",
-					addr.nl_pid);
+			syslog(LOG_WARNING,
+				"Received packet from untrusted pid:%u",
+				addr.nl_pid);
 			continue;
 		}
 
-- 
1.7.4.1

