Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaKCC20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:28:26 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:32902 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752796AbaKCC2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:28:24 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, <yingjoe.chen@gmail.com>,
        <hc.yen@mediatek.com>, <eddie.huang@mediatek.com>,
        <nathan.chung@mediatek.com>, <yh.chen@mediatek.com>
Subject: [PATCH] pinctrl: Fix path error in documentation
Date: Mon, 3 Nov 2014 10:28:11 +0800
Message-ID: <1414981691-14087-1-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pinconfig include file path.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 98eb94d..47d84b6 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -216,4 +216,4 @@ arguments are described below.
   or 0 to disable debouncing
 
 More in-depth documentation on these parameters can be found in
-<include/linux/pinctrl/pinconfig-generic.h>
+<include/linux/pinctrl/pinconf-generic.h>
-- 
1.8.1.1.dirty

