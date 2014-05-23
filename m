Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaEWVk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:40:29 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41574 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaEWVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:40:26 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, christoph.kohl@t-online.de,
        michael.hoefler@studium.uni-erlangen.de, rupert@rmuch.net
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, c@24.io
Subject: [PATCH] Staging: Silicom: Bypasslib: Fixed a couple of checkpatch.pl warnings
Date: Fri, 23 May 2014 14:39:43 -0700
Message-Id: <1400881183-23889-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations to fix the following warnings issued by checkpatch.pl:

drivers/staging/silicom/bypasslib/bypass.c:138: WARNING: Missing a blank line after declarations
drivers/staging/silicom/bypasslib/bypass.c:189: WARNING: Missing a blank line after declarations

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/silicom/bypasslib/bypass.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index a58251f..8e714a8 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -135,6 +135,7 @@ static int doit(int cmd, int if_index, int *data)
 static int is_dev_sd(int if_index)
 {
 	int ret = 0;
+
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
 	return ret >= 0 ? 1 : 0;
 }
@@ -186,6 +187,7 @@ static int is_bypass_dev(int if_index)
 static int is_bypass(int if_index)
 {
 	int ret = 0;
+
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
 	if (ret < 0)
--
1.7.9.5

