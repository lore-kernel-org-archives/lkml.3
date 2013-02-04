Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3BDL5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34137 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BDL5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 57/73] regulator: ab8500: Remove surplus include of id.h
Date: Mon,  4 Feb 2013 11:54:12 +0000
Message-Id: <1359978868-28736-58-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

It is not required.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Linus WALLEIJ <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 5e959b0..7e8e332 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -28,7 +28,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 #include <linux/slab.h>
-#include <mach/id.h>
 
 /**
  * struct ab8500_regulator_info - ab8500 regulator information
-- 
1.7.9.5

