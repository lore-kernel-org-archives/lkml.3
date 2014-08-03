Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaHCQI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 12:08:27 -0400
Received: from mx02.posteo.de ([89.146.194.165]:53463 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbaHCQI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 12:08:26 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: rtl8192ee: checkpatch: use tabs for indent
Date: Sun,  3 Aug 2014 18:06:49 +0200
Message-Id: <1407082009-17133-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tabs for code indent and use the kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
applies to -next20140801

 drivers/staging/rtl8192ee/regd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192ee/regd.c b/drivers/staging/rtl8192ee/regd.c
index 7272fae..7841447 100644
--- a/drivers/staging/rtl8192ee/regd.c
+++ b/drivers/staging/rtl8192ee/regd.c
@@ -363,8 +363,7 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
 static int _rtl92e_regd_init_wiphy(struct rtl_regulatory *reg,
 				   struct wiphy *wiphy,
 				   void (*reg_notifier)(struct wiphy *wiphy,
-						        struct regulatory_request *
-						        request))
+					struct regulatory_request *request))
 {
 	const struct ieee80211_regdomain *regd;
 
-- 
1.7.10.4

