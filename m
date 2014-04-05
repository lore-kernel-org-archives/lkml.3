Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaDEF5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 01:57:55 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63636 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaDEF5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 01:57:41 -0400
From: huanqi chi <chihuanqi@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        standby24x7@gmail.com, oat.elena@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        huanqi chi <chihuanqi@gmail.com>
Subject: [PATCH] staging rtl8188eu: add a blank line after declarations
Date: Sat,  5 Apr 2014 13:53:27 +0800
Message-Id: <1396677207-16562-1-git-send-email-chihuanqi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1396673803-8578-1-git-send-email-chihuanqi@gmail.com>
References: <1396673803-8578-1-git-send-email-chihuanqi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a coding style issue: Missing a blank line after declarations

Signed-off-by: huanqi chi <chihuanqi@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_br_ext.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_br_ext.c b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
index e843c6b..f97f05f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_br_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
@@ -442,6 +442,7 @@ static void __nat25_db_print(struct adapter *priv)
 void nat25_db_cleanup(struct adapter *priv)
 {
 	int i;
+
 	spin_lock_bh(&priv->br_ext_lock);
 
 	for (i = 0; i < NAT25_HASH_SIZE; i++) {
-- 
1.7.0.4

