Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3HWMHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:07:55 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56328 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3HWMHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:07:54 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, linus.walleij@linaro.org, sameo@linux.intel.com,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: ab8500-debugfs: Staticize local variables
Date: Fri, 23 Aug 2013 17:37:42 +0530
Message-Id: <1377259662-17401-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variables referenced only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 7d1f1b0..a0afa64 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -159,7 +159,7 @@ static struct hwreg_cfg hwreg_cfg = {
 
 static struct ab8500_prcmu_ranges *debug_ranges;
 
-struct ab8500_prcmu_ranges ab8500_debug_ranges[AB8500_NUM_BANKS] = {
+static struct ab8500_prcmu_ranges ab8500_debug_ranges[AB8500_NUM_BANKS] = {
 	[0x0] = {
 		.num_ranges = 0,
 		.range = NULL,
@@ -488,7 +488,7 @@ struct ab8500_prcmu_ranges ab8500_debug_ranges[AB8500_NUM_BANKS] = {
 	},
 };
 
-struct ab8500_prcmu_ranges ab8505_debug_ranges[AB8500_NUM_BANKS] = {
+static struct ab8500_prcmu_ranges ab8505_debug_ranges[AB8500_NUM_BANKS] = {
 	[0x0] = {
 		.num_ranges = 0,
 		.range = NULL,
@@ -847,7 +847,7 @@ struct ab8500_prcmu_ranges ab8505_debug_ranges[AB8500_NUM_BANKS] = {
 	},
 };
 
-struct ab8500_prcmu_ranges ab8540_debug_ranges[AB8500_NUM_BANKS] = {
+static struct ab8500_prcmu_ranges ab8540_debug_ranges[AB8500_NUM_BANKS] = {
 	[AB8500_M_FSM_RANK] = {
 		.num_ranges = 1,
 		.range = (struct ab8500_reg_range[]) {
@@ -1377,7 +1377,7 @@ void ab8500_dump_all_banks(struct device *dev)
 
 /* Space for 500 registers. */
 #define DUMP_MAX_REGS 700
-struct ab8500_register_dump
+static struct ab8500_register_dump
 {
 	u8 bank;
 	u8 reg;
-- 
1.7.4.1

