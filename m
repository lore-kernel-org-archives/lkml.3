Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaJTIL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:11:28 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47635 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752950AbaJTIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:10:14 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Documentation: bindings: pinctrl: document the generic groups property
Date: Mon, 20 Oct 2014 10:04:17 +0200
Message-Id: <1413792260-4265-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group-based drivers use a groups property to define on which groups a
mux function is applied to. Document it.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index fa40a177164c..7a1adc08b366 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -141,6 +141,7 @@ Supported generic properties are:
 pins			- the list of pins that properties in the node
 			  apply to
 function		- the mux function to select
+groups			- a list of groups a mux function is applied to
 bias-disable		- disable any pin bias
 bias-high-impedance	- high impedance mode ("third-state", "floating")
 bias-bus-hold		- latch weakly
-- 
1.9.1

