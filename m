Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaGVLMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:12:17 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:41692 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaGVLMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:12:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/19] mfd: wm8997-tables: Suppress 'line over 80 chars' warnings
Date: Tue, 22 Jul 2014 12:11:25 +0100
Message-Id: <1406027485-15657-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: line over 80 characters
+       { 0x00000068, 0x01FF },    /* R104   - Always On Triggers Sequence Select 3 */

WARNING: line over 80 characters
+       { 0x00000069, 0x01FF },    /* R105   - Always On Triggers Sequence Select 4 */

WARNING: line over 80 characters
+       { 0x0000006A, 0x01FF },    /* R106   - Always On Triggers Sequence Select 5 */

WARNING: line over 80 characters
+       { 0x0000006B, 0x01FF },    /* R107   - Always On Triggers Sequence Select 6 */

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm8997-tables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
index c7a81da..04bc6d5 100644
--- a/drivers/mfd/wm8997-tables.c
+++ b/drivers/mfd/wm8997-tables.c
@@ -174,10 +174,10 @@ static const struct reg_default wm8997_reg_default[] = {
 	{ 0x00000062, 0x01FF },    /* R98    - Sample Rate Sequence Select 2 */
 	{ 0x00000063, 0x01FF },    /* R99    - Sample Rate Sequence Select 3 */
 	{ 0x00000064, 0x01FF },    /* R100   - Sample Rate Sequence Select 4 */
-	{ 0x00000068, 0x01FF },    /* R104   - Always On Triggers Sequence Select 3 */
-	{ 0x00000069, 0x01FF },    /* R105   - Always On Triggers Sequence Select 4 */
-	{ 0x0000006A, 0x01FF },    /* R106   - Always On Triggers Sequence Select 5 */
-	{ 0x0000006B, 0x01FF },    /* R107   - Always On Triggers Sequence Select 6 */
+	{ 0x00000068, 0x01FF },    /* R104   - AlwaysOn Triggers Seq Select 3 */
+	{ 0x00000069, 0x01FF },    /* R105   - AlwaysOn Triggers Seq Select 4 */
+	{ 0x0000006A, 0x01FF },    /* R106   - AlwaysOn Triggers Seq Select 5 */
+	{ 0x0000006B, 0x01FF },    /* R107   - AlwaysOn Triggers Seq Select 6 */
 	{ 0x00000070, 0x0000 },    /* R112   - Comfort Noise Generator */
 	{ 0x00000090, 0x0000 },    /* R144   - Haptics Control 1 */
 	{ 0x00000091, 0x7FFF },    /* R145   - Haptics Control 2 */
-- 
1.8.3.2

