Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaGGMEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:04:38 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:63457 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaGGMEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:04:36 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of: Add vendor prefix for Innolux Corporation
Date: Mon,  7 Jul 2014 14:04:32 +0200
Message-Id: <1404734672-14671-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

According to Wikipedia, Innolux started out in 2003 as InnoLux Display
Corporation and merged with Chi Mei Optoelectronics in 2006. It went by
the name of Chimei Innolux Corporation for a while and changed its name
back to Innolux Corporation in late 2012.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 4c4883e05df7..c9adab8eb2dc 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -63,6 +63,7 @@ ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
 iom	Iomega Corporation
 img	Imagination Technologies Ltd.
+innolux	Innolux Corporation
 intel	Intel Corporation
 intercontrol	Inter Control Group
 isee	ISEE 2007 S.L.
-- 
2.0.1

