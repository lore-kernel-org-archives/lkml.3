Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbbANMMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:12:08 -0500
Received: from [119.145.14.66] ([119.145.14.66]:24585 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbbANMMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:12:06 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiakaixu@huawei.com>,
        <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix the parameter name of etm_writel_cp14()
Date: Wed, 14 Jan 2015 20:04:47 +0800
Message-ID: <1421237087-68021-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54B65CA6.01EE,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1c80d385e38c9260b6999ff5010a3e5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This minor change is necessary to make more sense.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/coresight-priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/coresight-priv.h b/drivers/coresight/coresight-priv.h
index 7b3372f..62fcd98 100644
--- a/drivers/coresight/coresight-priv.h
+++ b/drivers/coresight/coresight-priv.h
@@ -57,7 +57,7 @@ extern int etm_readl_cp14(u32 off, unsigned int *val);
 extern int etm_writel_cp14(u32 off, u32 val);
 #else
 static inline int etm_readl_cp14(u32 off, unsigned int *val) { return 0; }
-static inline int etm_writel_cp14(u32 val, u32 off) { return 0; }
+static inline int etm_writel_cp14(u32 off, u32 val) { return 0; }
 #endif
 
 #endif
-- 
1.8.5.5

