Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbaJVJuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:50:40 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:58509 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaJVJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:50:39 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH] clk: st: Spelling s/stucture/structure/
Date: Wed, 22 Oct 2014 11:50:40 +0200
Message-Id: <1413971440-27716-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mike Turquette <mturquette@linaro.org>
---
 Documentation/devicetree/bindings/clock/st/st,flexgen.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/st/st,flexgen.txt b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
index 1d3ace08817273ac..b7ee5c7e0f751177 100644
--- a/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
@@ -11,7 +11,7 @@ Please find an example below:
 
     Clockgen block diagram
     -------------------------------------------------------------------
-   |                     Flexgen stucture                              |
+   |                     Flexgen structure                             |
    |                  ---------------------------------------------    |
    |                 |    -------       --------       --------    |   |
 clk_sysin            |   |       |     |        |     |        |   |   |
-- 
1.9.1

