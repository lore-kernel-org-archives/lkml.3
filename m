Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3DLQkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:40:15 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63647 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3DLQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:40:14 -0400
Message-ID: <1365784808.4285.0.camel@phoenix>
Subject: [PATCH] Documentation: DT: usage-model: Fix typo for
 arch/arm/kernel/devtree.c file path
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 13 Apr 2013 00:40:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/kernel/devicetree.c does not exist.
The correct file path is arch/arm/kernel/devtree.c.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 Documentation/devicetree/usage-model.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/usage-model.txt b/Documentation/devicetree/usage-model.txt
index ef9d06c..8202ce5 100644
--- a/Documentation/devicetree/usage-model.txt
+++ b/Documentation/devicetree/usage-model.txt
@@ -106,7 +106,7 @@ In the majority of cases, the machine identity is irrelevant, and the
 kernel will instead select setup code based on the machine's core
 CPU or SoC.  On ARM for example, setup_arch() in
 arch/arm/kernel/setup.c will call setup_machine_fdt() in
-arch/arm/kernel/devicetree.c which searches through the machine_desc
+arch/arm/kernel/devtree.c which searches through the machine_desc
 table and selects the machine_desc which best matches the device tree
 data.  It determines the best match by looking at the 'compatible'
 property in the root device tree node, and comparing it with the
-- 
1.7.10.4



