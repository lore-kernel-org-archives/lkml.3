Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab3CYOrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:47:53 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61905 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3CYOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:47:50 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/4] pinctrl: fix typo in header
Date: Mon, 25 Mar 2013 15:47:20 +0100
Message-Id: <1364222843-30305-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly, "node" was meant instead of "not"

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index ee72f1f..6d3d400 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -72,7 +72,7 @@ struct pinctrl {
 
 /**
  * struct pinctrl_state - a pinctrl state for a device
- * @node: list not for struct pinctrl's @states field
+ * @node: list node for struct pinctrl's @states field
  * @name: the name of this state
  * @settings: a list of settings for this state
  */
-- 
1.7.2.5

