Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3JUJSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:18:15 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44999 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab3JUJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:18:13 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] pinctrl: mvebu: remove redundant of_match_ptr
Date: Mon, 21 Oct 2013 14:47:14 +0530
Message-Id: <1382347034-32332-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-370.c |    2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  |    2 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c       |    2 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index 48e21a2..ae1f760 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -408,7 +408,7 @@ static struct platform_driver armada_370_pinctrl_driver = {
 	.driver = {
 		.name = "armada-370-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(armada_370_pinctrl_of_match),
+		.of_match_table = armada_370_pinctrl_of_match,
 	},
 	.probe = armada_370_pinctrl_probe,
 	.remove = armada_370_pinctrl_remove,
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index ab5dc04..843a51f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -455,7 +455,7 @@ static struct platform_driver armada_xp_pinctrl_driver = {
 	.driver = {
 		.name = "armada-xp-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(armada_xp_pinctrl_of_match),
+		.of_match_table = armada_xp_pinctrl_of_match,
 	},
 	.probe = armada_xp_pinctrl_probe,
 	.remove = armada_xp_pinctrl_remove,
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 360b9b2..4726839 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -806,7 +806,7 @@ static struct platform_driver dove_pinctrl_driver = {
 	.driver = {
 		.name = "dove-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(dove_pinctrl_of_match),
+		.of_match_table = dove_pinctrl_of_match,
 	},
 	.probe = dove_pinctrl_probe,
 	.remove = dove_pinctrl_remove,
diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index cdd483d..6b504b5 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -471,7 +471,7 @@ static struct platform_driver kirkwood_pinctrl_driver = {
 	.driver = {
 		.name = "kirkwood-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(kirkwood_pinctrl_of_match),
+		.of_match_table = kirkwood_pinctrl_of_match,
 	},
 	.probe = kirkwood_pinctrl_probe,
 	.remove = kirkwood_pinctrl_remove,
-- 
1.7.9.5

