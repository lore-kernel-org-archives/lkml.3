Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJEWBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:01:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62726 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaJEWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:01:17 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 4/7] of: add vendor prefix for Tronsmart
Date: Sun,  5 Oct 2014 23:59:16 +0200
Message-Id: <1412546359-15062-5-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412546359-15062-1-git-send-email-b.galvani@gmail.com>
References: <1412546359-15062-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Tronsmart to the list of device tree vendor prefixes.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index c681434..92a1798 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -141,6 +141,7 @@ tlm	Trusted Logic Mobility
 toradex	Toradex AG
 toshiba	Toshiba Corporation
 toumaz	Toumaz
+tronsmart	Tronsmart
 usi	Universal Scientifc Industrial Co., Ltd.
 v3	V3 Semiconductor
 variscite	Variscite Ltd.
-- 
1.9.1

