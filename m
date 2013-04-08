Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264Ab3DHKHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:07:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935784Ab3DHJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Masatake YAMATO <yamato@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 063/102] thermal: shorten too long mcast group name
Date: Mon,  8 Apr 2013 10:50:18 +0100
Message-Id: <1365414657-29191-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masatake YAMATO <yamato@redhat.com>

commit 73214f5d9f33b79918b1f7babddd5c8af28dd23d upstream.

The original name is too long.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/thermal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 796f1ff..1662047 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -108,7 +108,7 @@ struct thermal_zone_device {
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"
 #define THERMAL_GENL_VERSION                    0x01
-#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_group"
+#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
 
 enum events {
 	THERMAL_AUX0,
-- 
1.8.1.2

