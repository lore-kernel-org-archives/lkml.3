Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3A2Jtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:49:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45599 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3A2JtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:49:12 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        dg77.kim@samsung.com
Subject: [PATCH 3/3] extcon: max77693: Make max77693_extcon_cable static
Date: Tue, 29 Jan 2013 15:10:02 +0530
Message-Id: <1359452402-15885-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
References: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'max77693_extcon_cable' is used only in this file. Hence
make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index fb65276..a645268 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -185,7 +185,7 @@ enum {
 	_EXTCON_CABLE_NUM,
 };
 
-const char *max77693_extcon_cable[] = {
+static const char *max77693_extcon_cable[] = {
 	[EXTCON_CABLE_USB]			= "USB",
 	[EXTCON_CABLE_USB_HOST]			= "USB-Host",
 	[EXTCON_CABLE_TA]			= "TA",
-- 
1.7.4.1

