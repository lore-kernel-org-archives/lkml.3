Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaIJHP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:15:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45768 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaIJHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:15:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH] checkpatch: struct of_device_id should usually be const
Date: Wed, 10 Sep 2014 09:15:46 +0200
Message-Id: <1410333346-29062-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b385bcbbf2f5..01f503e0ebbd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4941,6 +4941,7 @@ sub process {
 				mtrr_ops|
 				neigh_ops|
 				nlmsvc_binding|
+				of_device_id|
 				pci_raw_ops|
 				pipe_buf_operations|
 				platform_hibernation_ops|
-- 
2.1.0

