Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3CaPBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 11:01:18 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44193 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3CaPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 11:01:17 -0400
Message-ID: <1364742071.3834.4.camel@phoenix>
Subject: [PATCH 2/3] pwm: puv3: Remove unused enabled filed from struct
 puv3_pwm_chip
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Qin Rui <qinrui@mprc.pku.edu.cn>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 23:01:11 +0800
In-Reply-To: <1364741987.3834.2.camel@phoenix>
References: <1364741987.3834.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-puv3.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pwm/pwm-puv3.c b/drivers/pwm/pwm-puv3.c
index db964e6..d1eb499 100644
--- a/drivers/pwm/pwm-puv3.c
+++ b/drivers/pwm/pwm-puv3.c
@@ -27,7 +27,6 @@ struct puv3_pwm_chip {
 	struct pwm_chip chip;
 	void __iomem *base;
 	struct clk *clk;
-	bool enabled;
 };
 
 static inline struct puv3_pwm_chip *to_puv3(struct pwm_chip *chip)
-- 
1.7.10.4



