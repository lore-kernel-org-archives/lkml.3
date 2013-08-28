Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3H1LjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:39:04 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14873 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3H1LjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:39:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 04:39:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] pinctrl: utils: include export.h to avoid warnings
Date: Wed, 28 Aug 2013 17:26:22 +0530
Message-ID: <1377690982-11102-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include "linux/export.h" to avoid following warnings during compilation:

/***
pinctrl/pinctrl-utils.c:53:1: warning: data definition has no type or storage class [enabled by default]
pinctrl/pinctrl-utils.c:53:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
pinctrl/pinctrl-utils.c:53:1: warning: parameter names (without types) in function declaration [enabled by default]
pinctrl/pinctrl-utils.c:70:1: warning: data definition has no type or storage class [enabled by default]
pinctrl/pinctrl-utils.c:70:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
pinctrl/pinctrl-utils.c:70:1: warning: parameter names (without types) in function declaration [enabled by default]
pinctrl/pinctrl-utils.c:98:1: warning: data definition has no type or storage class [enabled by default]
pinctrl/pinctrl-utils.c:98:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
pinctrl/pinctrl-utils.c:98:1: warning: parameter names (without types) in function declaration [enabled by default]
pinctrl/pinctrl-utils.c:122:1: warning: data definition has no type or storage class [enabled by default]
pinctrl/pinctrl-utils.c:122:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
pinctrl/pinctrl-utils.c:122:1: warning: parameter names (without types) in function declaration [enabled by default]
pinctrl/pinctrl-utils.c:135:1: warning: data definition has no type or storage class [enabled by default]
pinctrl/pinctrl-utils.c:135:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
pinctrl/pinctrl-utils.c:135:1: warning: parameter names (without types) in function declaration [enabled by default]
**/

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-utils.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-utils.c b/drivers/pinctrl/pinctrl-utils.c
index 48277e0..d77693f 100644
--- a/drivers/pinctrl/pinctrl-utils.c
+++ b/drivers/pinctrl/pinctrl-utils.c
@@ -20,6 +20,7 @@
  * 02111-1307, USA
  */
 #include <linux/device.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/of.h>
-- 
1.7.1.1

