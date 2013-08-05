Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3HEWFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:05:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57606 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3HEWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:05:16 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] pinctrl: add generic pins and functions properties
Date: Mon,  5 Aug 2013 15:56:00 -0600
Message-Id: <1375739760-18833-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375739760-18833-1-git-send-email-swarren@wwwdotorg.org>
References: <1375739760-18833-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

pinctrl bindings can benefit from generic property names that define
which pins a "pin configuration node" affects, and which mux function
to select onto those pins. Document new properties for this purpose so
that other bindings may refer to them.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 31b0cb9..237823a 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -138,6 +138,9 @@ structure of the DT nodes that contain these properties.
 
 Supported generic properties are:
 
+pins			- the list of pins that properties in the node
+			  apply to
+function		- the mux function to select
 bias-disable		- disable any pin bias
 bias-high-impedance	- high impedance mode ("third-state", "floating")
 bias-bus-hold		- latch weakly
-- 
1.8.1.5

