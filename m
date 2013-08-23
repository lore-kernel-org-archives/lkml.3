Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3HWKLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:11:25 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53138 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3HWKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:11:21 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 2/3] mfd: timberdale: Remove redundant break
Date: Fri, 23 Aug 2013 15:41:04 +0530
Message-Id: <1377252665-7152-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
References: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

break after goto is unreachable. Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/timberdale.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 4c9c149..57dd89d 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -781,7 +781,6 @@ static int timb_probe(struct pci_dev *dev,
 			priv->fw.major, priv->fw.minor, ip_setup);
 		err = -ENODEV;
 		goto err_mfd;
-		break;
 	}
 
 	if (err) {
-- 
1.7.4.1

