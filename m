Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaHTO3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:29:39 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:38685 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbaHTO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:29:38 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: viresh.linux@gmail.com, linus.walleij@linaro.org
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] pinctrl: spear: Make of_device_id array const
Date: Wed, 20 Aug 2014 19:56:40 +0530
Message-Id: <1408544800-24628-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/pinctrl/spear/pinctrl-spear1310.c |    2 +-
 drivers/pinctrl/spear/pinctrl-spear1340.c |    2 +-
 drivers/pinctrl/spear/pinctrl-spear300.c  |    2 +-
 drivers/pinctrl/spear/pinctrl-spear310.c  |    2 +-
 drivers/pinctrl/spear/pinctrl-spear320.c  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-spear1310.c b/drivers/pinctrl/spear/pinctrl-spear1310.c
index 1a8bbfe..6d57d43 100644
--- a/drivers/pinctrl/spear/pinctrl-spear1310.c
+++ b/drivers/pinctrl/spear/pinctrl-spear1310.c
@@ -2692,7 +2692,7 @@ static struct spear_pinctrl_machdata spear1310_machdata = {
 	.modes_supported = false,
 };
 
-static struct of_device_id spear1310_pinctrl_of_match[] = {
+static const struct of_device_id spear1310_pinctrl_of_match[] = {
 	{
 		.compatible = "st,spear1310-pinmux",
 	},
diff --git a/drivers/pinctrl/spear/pinctrl-spear1340.c b/drivers/pinctrl/spear/pinctrl-spear1340.c
index 873966e..d243e43 100644
--- a/drivers/pinctrl/spear/pinctrl-spear1340.c
+++ b/drivers/pinctrl/spear/pinctrl-spear1340.c
@@ -2008,7 +2008,7 @@ static struct spear_pinctrl_machdata spear1340_machdata = {
 	.modes_supported = false,
 };
 
-static struct of_device_id spear1340_pinctrl_of_match[] = {
+static const struct of_device_id spear1340_pinctrl_of_match[] = {
 	{
 		.compatible = "st,spear1340-pinmux",
 	},
diff --git a/drivers/pinctrl/spear/pinctrl-spear300.c b/drivers/pinctrl/spear/pinctrl-spear300.c
index 4777c0d..9db83e9 100644
--- a/drivers/pinctrl/spear/pinctrl-spear300.c
+++ b/drivers/pinctrl/spear/pinctrl-spear300.c
@@ -646,7 +646,7 @@ static struct spear_function *spear300_functions[] = {
 	&gpio1_function,
 };
 
-static struct of_device_id spear300_pinctrl_of_match[] = {
+static const struct of_device_id spear300_pinctrl_of_match[] = {
 	{
 		.compatible = "st,spear300-pinmux",
 	},
diff --git a/drivers/pinctrl/spear/pinctrl-spear310.c b/drivers/pinctrl/spear/pinctrl-spear310.c
index ed1d360..db775a4 100644
--- a/drivers/pinctrl/spear/pinctrl-spear310.c
+++ b/drivers/pinctrl/spear/pinctrl-spear310.c
@@ -371,7 +371,7 @@ static struct spear_function *spear310_functions[] = {
 	&tdm_function,
 };
 
-static struct of_device_id spear310_pinctrl_of_match[] = {
+static const struct of_device_id spear310_pinctrl_of_match[] = {
 	{
 		.compatible = "st,spear310-pinmux",
 	},
diff --git a/drivers/pinctrl/spear/pinctrl-spear320.c b/drivers/pinctrl/spear/pinctrl-spear320.c
index b8e290a..80fbd68 100644
--- a/drivers/pinctrl/spear/pinctrl-spear320.c
+++ b/drivers/pinctrl/spear/pinctrl-spear320.c
@@ -3410,7 +3410,7 @@ static struct spear_function *spear320_functions[] = {
 	&i2c2_function,
 };
 
-static struct of_device_id spear320_pinctrl_of_match[] = {
+static const struct of_device_id spear320_pinctrl_of_match[] = {
 	{
 		.compatible = "st,spear320-pinmux",
 	},
-- 
1.7.9.5

