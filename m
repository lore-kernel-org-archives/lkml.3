Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaADCpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:45:21 -0500
Received: from mout.gmx.net ([212.227.17.20]:55225 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaADCnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:25 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 15/15] tpm/tpm-sysfs: active_show() can be static
Date: Sat,  4 Jan 2014 03:44:49 +0100
Message-Id: <1388803489-13258-15-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:KDlZ/wpQ5UpfU1yQ1AosF6gpEvAsjg6LfyXuGJBU2dGCiIX0UdB
 k2BPDCJ9QCW3pHvYaYL17/BUGBL6OSwzQCLcDqUsT4f++92ugearpWzAWAKcXQReHS9hbf0
 bU4IooZgUYIvuyI/K7RhH/i2V4KceAVWcI27XB87EIiC8m6KcrhX3F2zwzJkk3l3zTeIhr5
 KPH2P5gBYxDFQS/SFjqaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

so we make it static

CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index c3503cb..01730a2 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -148,7 +148,7 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(enabled);
 
-ssize_t active_show(struct device *dev, struct device_attribute *attr,
+static ssize_t active_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
 {
 	cap_t cap;
-- 
1.8.1.5

