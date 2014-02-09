Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaBIOca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:32:30 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57625 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaBIOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:32:28 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2003/13=5D=20net=3A=20Include=20appropriate=20header=20file=20in=20caif/cfsrvl=2Ec?=
Date: Sun,  9 Feb 2014 20:02:16 +0530
Message-Id: <6b6ceef0f79bffec0ec14784dc3d921d53231a3b.1391955924.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file net/caif/caif_dev.h in caif/cfsrvl.c
because it has prototype declaration of functions defined in
caif/cfsrvl.c.

This eliminates the following warning in caif/cfsrvl.c:
net/caif/cfsrvl.c:198:6: warning: no previous prototype for ‘caif_free_client’ [-Wmissing-prototypes]
net/caif/cfsrvl.c:208:6: warning: no previous prototype for ‘caif_client_register_refcnt’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 net/caif/cfsrvl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/caif/cfsrvl.c b/net/caif/cfsrvl.c
index 353f793..a6e1154 100644
--- a/net/caif/cfsrvl.c
+++ b/net/caif/cfsrvl.c
@@ -15,6 +15,7 @@
 #include <net/caif/caif_layer.h>
 #include <net/caif/cfsrvl.h>
 #include <net/caif/cfpkt.h>
+#include <net/caif/caif_dev.h>
 
 #define SRVL_CTRL_PKT_SIZE 1
 #define SRVL_FLOW_OFF 0x81
-- 
1.7.9.5

