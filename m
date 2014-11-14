Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaKNFPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:15:19 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64110 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaKNFPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:15:15 -0500
From: Howard Chen <ibanezchen@gmail.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Howard Chen <ibanezchen@gmail.com>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 3/3] dt-bindings: add documentation for Mediatek SoC
Date: Fri, 14 Nov 2014 13:14:54 +0800
Message-Id: <1415942094-11451-3-git-send-email-ibanezchen@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415942094-11451-1-git-send-email-ibanezchen@gmail.com>
References: <1415942094-11451-1-git-send-email-ibanezchen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a DT binding documentation for the MT6592 SoC from Mediatek.

Signed-off-by: Howard Chen <ibanezchen@gmail.com>
---
 Documentation/devicetree/bindings/arm/mediatek.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/mediatek.txt b/Documentation/devicetree/bindings/arm/mediatek.txt
index fa25226..1d2d151 100644
--- a/Documentation/devicetree/bindings/arm/mediatek.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek.txt
@@ -1,10 +1,10 @@
 Mediatek MT6589 Platforms Device Tree Bindings
 
-Boards with a SoC of the Mediatek MT6589 shall have the following property:
+Boards with a SoC from Mediatek shall have the following property:
 
 Required root node property:
 
-compatible: must contain "mediatek,mt6589"
+compatible: must contain one of "mediatek,mt6589", "mediatek,mt6592"
 
 
 Supported boards:
@@ -12,3 +12,6 @@ Supported boards:
 - bq Aquaris5 smart phone:
     Required root node properties:
       - compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
+
+- Evaluation board for MT6592:
+      - compatible = "mediatek,mt6592-evb", "mediatek,mt6592";
-- 
1.9.1

