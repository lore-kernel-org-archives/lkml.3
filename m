Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3FDOIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:08:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3FDOIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 70/70] xen-netfront: frags -> slots in log message
Date: Tue,  4 Jun 2013 15:07:26 +0100
Message-Id: <1370354846-14213-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 697089dc13c52d668322ac6cb8548520de27ed0e upstream.

Also fix a typo in comment.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netfront.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 9f09606..526702d 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -679,7 +679,7 @@ static int xennet_get_responses(struct netfront_info *np,
 		/*
 		 * This definitely indicates a bug, either in this driver or in
 		 * the backend driver. In future this should flag the bad
-		 * situation to the system controller to reboot the backed.
+		 * situation to the system controller to reboot the backend.
 		 */
 		if (ref == GRANT_INVALID_REF) {
 			if (net_ratelimit())
@@ -715,7 +715,7 @@ next:
 
 	if (unlikely(slots > max)) {
 		if (net_ratelimit())
-			dev_warn(dev, "Too many frags\n");
+			dev_warn(dev, "Too many slots\n");
 		err = -E2BIG;
 	}
 
-- 
1.8.1.2

