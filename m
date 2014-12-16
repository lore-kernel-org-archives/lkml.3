Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaLPRf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:35:58 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40026 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaLPRf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:35:57 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: arnd@arndb.de
Cc: gregkh@linuxfoundation.org, michael.hennerich@analog.com,
        linux-kernel@vger.kernel.org, md.jamalmohiuddin@gmail.com
Subject: [PATCH 1/2] misc:ad525x_dpot: Fix missing blank after declaration coding style issue in ad525x_dpot.c
Date: Tue, 16 Dec 2014 23:05:36 +0530
Message-Id: <1418751336-7295-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This  is a patch to ad525x_dpot.c file that fixes up a missing blank line after declaration warning found by checkpatch.pl issue

Signed-off-by: Mohammad Jamal<md.jamalmohiuddin@gmail.com>
---
 drivers/misc/ad525x_dpot.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index a43053d..32f9072 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -176,6 +176,7 @@ static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
 {
 	int value;
 	unsigned ctrl = 0;
+
 	switch (dpot->uid) {
 	case DPOT_UID(AD5246_ID):
 	case DPOT_UID(AD5247_ID):
-- 
1.7.9.5

