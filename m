Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaEAVn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:43:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59130 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaEAVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:43:56 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH] spmi: of: fixup generic SPMI devicetree binding example
Date: Thu,  1 May 2014 16:40:26 -0500
Message-Id: <1398980426-23877-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic SPMI example was missing an equal sign in the assignment
of the #size-cells property.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 Documentation/devicetree/bindings/spmi/spmi.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/spmi/spmi.txt b/Documentation/devicetree/bindings/spmi/spmi.txt
index 462a42f..4bb10d1 100644
--- a/Documentation/devicetree/bindings/spmi/spmi.txt
+++ b/Documentation/devicetree/bindings/spmi/spmi.txt
@@ -26,7 +26,7 @@ Each child node must have one and only one 'reg' entry of type SPMI_USID.
 		reg = <...>;
 
 		#address-cells = <2>;
-		#size-cells <0>;
+		#size-cells = <0>;
 
 		child@0 {
 			compatible = "...";
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

