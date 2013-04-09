Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936234Ab3DIUNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:13:45 -0400
Received: from 8bytes.org ([85.214.48.195]:36435 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936208Ab3DIUNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:35 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 9/9] iommu/amd: Document ivrs_ioapic and ivrs_hpet parameters
Date: Tue,  9 Apr 2013 22:13:04 +0200
Message-Id: <1365538384-12426-10-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:34 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766e23676475836759
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the new kernel commandline parameters in the
appropriate file.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 Documentation/kernel-parameters.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..2848b1b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1226,6 +1226,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	iucv=		[HW,NET]
 
+	ivrs_ioapic	[HW,X86_64]
+			Provide an override to the IOAPIC-ID<->DEVICE-ID
+			mapping provided in the IVRS ACPI table. For
+			example, to map IOAPIC-ID decimal 10 to
+			PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=00:14.0
+
+	ivrs_hpet	[HW,X86_64]
+			Provide an override to the HPET-ID<->DEVICE-ID
+			mapping provided in the IVRS ACPI table. For
+			example, to map HPET-ID decimal 0 to
+			PCI device 00:14.0 write the parameter as:
+				ivrs_hpet[0]=00:14.0
+
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
-- 
1.7.9.5


