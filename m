Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaFMRBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:01:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaFMRBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:01:34 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: [PATCH v5 5/7] arch/x86: Replace plain strings with constants
Date: Fri, 13 Jun 2014 19:00:21 +0200
Message-Id: <1402678823-24589-6-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5 - suggestions/fixes:
   - do not change indentation
     (suggested by Matt Fleming).

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 78a0e62..41ead8d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -924,10 +924,10 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
+		     EFI32_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4)) {
+		     EFI64_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
-- 
1.7.10.4

