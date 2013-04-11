Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935625Ab3DKUtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:49:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935448Ab3DKUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:53 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LErZNBmOVXAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ImSVWQCH268A:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202611.210538692@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Masatake YAMATO <yamato@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 152/171 ] thermal: shorten too long mcast group name
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0152-thermal-shorten-too-long-mcast-group-name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Masatake YAMATO <yamato@redhat.com>

[ Upstream commit 73214f5d9f33b79918b1f7babddd5c8af28dd23d ]

The original name is too long.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/thermal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 4b94a61..30c223b 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -122,7 +122,7 @@ struct thermal_zone_device {
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"
 #define THERMAL_GENL_VERSION                    0x01
-#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_group"
+#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
 
 enum events {
 	THERMAL_AUX0,
-- 
1.7.10.4


