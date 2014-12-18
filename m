Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaLRBqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:46:42 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63091 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLRBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:46:40 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: arnd@arndb.de
Cc: gregkh@linuxfoundation.org, michael.hennerich@analog.com,
        linux-kernel@vger.kernel.org,
        Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH 1/2] ad525x_dpot: Add a blank line after declaration
Date: Thu, 18 Dec 2014 07:16:26 +0530
Message-Id: <1418867186-5221-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declaration to fix the warning of checkpatch.pl

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
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

