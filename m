Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3A2JtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:49:09 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53679 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3A2JtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:49:06 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        dg77.kim@samsung.com
Subject: [PATCH 1/3] extcon: max8997: Make max8997_extcon_cable static
Date: Tue, 29 Jan 2013 15:10:00 +0530
Message-Id: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'max8997_extcon_cable' is used only in this file. Hence make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index df9358e..7039541 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -109,7 +109,7 @@ struct max8997_muic_info {
 	struct extcon_dev	*edev;
 };
 
-const char *max8997_extcon_cable[] = {
+static const char *max8997_extcon_cable[] = {
 	[0] = "USB",
 	[1] = "USB-Host",
 	[2] = "TA",
-- 
1.7.4.1

