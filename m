Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3FRJTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:19:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65265 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3FRJT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:19:26 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 4/4] pinctrl: Staticize local symbols
Date: Tue, 18 Jun 2013 14:34:27 +0530
Message-Id: <1371546267-22093-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symbols referenced only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 32eb7e2..86b5370 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -41,13 +41,13 @@
 static bool pinctrl_dummy_state;
 
 /* Mutex taken to protect pinctrl_list */
-DEFINE_MUTEX(pinctrl_list_mutex);
+static DEFINE_MUTEX(pinctrl_list_mutex);
 
 /* Mutex taken to protect pinctrl_maps */
 DEFINE_MUTEX(pinctrl_maps_mutex);
 
 /* Mutex taken to protect pinctrldev_list */
-DEFINE_MUTEX(pinctrldev_list_mutex);
+static DEFINE_MUTEX(pinctrldev_list_mutex);
 
 /* Global list of pin control devices (struct pinctrl_dev) */
 static LIST_HEAD(pinctrldev_list);
-- 
1.7.9.5

