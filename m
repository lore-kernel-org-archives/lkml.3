Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaAVDbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:31:24 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60911 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaAVDbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:31:14 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v5 5/8] ARM: brcmstb: add CPU binding for Broadcom Brahma15
Date: Tue, 21 Jan 2014 19:30:49 -0800
Message-Id: <1390361452-3124-6-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1390361452-3124-1-git-send-email-marc.ceeeee@gmail.com>
References: <1390361452-3124-1-git-send-email-marc.ceeeee@gmail.com>
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
index 9130435..0cd1e25 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -163,6 +163,7 @@ nodes to be present and contain the properties described below.
 			    "arm,cortex-r4"
 			    "arm,cortex-r5"
 			    "arm,cortex-r7"
+			    "brcm,brahma-b15"
 			    "faraday,fa526"
 			    "intel,sa110"
 			    "intel,sa1100"
-- 
1.7.1

