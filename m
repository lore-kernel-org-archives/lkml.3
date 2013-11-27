Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3K0AXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:23:32 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39167 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3K0AX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:23:28 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v2 3/6] ARM: brcmstb: add CPU binding for Broadcom Brahma15
Date: Tue, 26 Nov 2013 16:22:25 -0800
Message-Id: <1385511748-27869-4-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Broadcom Brahma B15 CPU to the DT CPU binding list.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/arm/cpus.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 9130435..423b879 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -163,6 +163,7 @@ nodes to be present and contain the properties described below.
 			    "arm,cortex-r4"
 			    "arm,cortex-r5"
 			    "arm,cortex-r7"
+			    "brcm,brahma15"
 			    "faraday,fa526"
 			    "intel,sa110"
 			    "intel,sa1100"
-- 
1.7.1

