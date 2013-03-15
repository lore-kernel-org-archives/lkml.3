Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3COFMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:12:06 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41635 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3COFMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:12:05 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 2/2] pinctrl: generic: Fix checkpatch errors
Date: Fri, 15 Mar 2013 10:23:16 +0530
Message-Id: <1363323196-29628-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363323196-29628-1-git-send-email-sachin.kamat@linaro.org>
References: <1363323196-29628-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following type of checkpatch errors:
ERROR: space required before the open parenthesis '('

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinconf-generic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 791e6a3..2ad5a8d 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -60,7 +60,7 @@ void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
 	if (!ops->is_generic)
 		return;
 
-	for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
+	for (i = 0; i < ARRAY_SIZE(conf_items); i++) {
 		unsigned long config;
 		int ret;
 
@@ -95,7 +95,7 @@ void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
 	if (!ops->is_generic)
 		return;
 
-	for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
+	for (i = 0; i < ARRAY_SIZE(conf_items); i++) {
 		unsigned long config;
 		int ret;
 
@@ -126,7 +126,7 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 {
 	int i;
 
-	for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
+	for (i = 0; i < ARRAY_SIZE(conf_items); i++) {
 		if (pinconf_to_config_param(config) != conf_items[i].param)
 			continue;
 		seq_printf(s, "%s: 0x%x", conf_items[i].display,
-- 
1.7.4.1

