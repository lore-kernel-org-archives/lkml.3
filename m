Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966473AbaFTRuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:50:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57401 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966344AbaFTRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:50:07 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 3/3] Staging: rtl8192u: r8192U_wx.c Fixed a code-style error about trailing whitespace
Date: Fri, 20 Jun 2014 10:49:56 -0700
Message-Id: <1403286596-6756-3-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403286596-6756-1-git-send-email-c@24.io>
References: <1403286596-6756-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following error reported by running checkpatch.pl

ERROR: trailing whitespace

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index cccc88b..6808e87 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -952,7 +952,7 @@ static const struct iw_priv_args r8192_private_args[] = {
 
 
 static iw_handler r8192_private_handler[] = {
-	r8192_wx_set_crcmon, 
+	r8192_wx_set_crcmon,
 	r8192_wx_set_scan_type,
 	r8192_wx_set_rawtx,
 	r8192_wx_force_reset,
-- 
1.9.1

