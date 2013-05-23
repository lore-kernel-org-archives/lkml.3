Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137Ab3EWPk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:40:28 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:23727
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876Ab3EWPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:40:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN9CV5-02-51Q-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 2/3] x86, microcode, intel: Correct typo in printk
Date: Thu, 23 May 2013 10:40:17 -0500
Message-ID: <1369323618-5820-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

User-visible so correct it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/microcode_intel_early.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 88f0edc..5e558eb 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -529,7 +529,7 @@ int save_mc_for_early(u8 *mc)
 	 */
 	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
 	if (ret) {
-		pr_err("Can not save microcode patch.\n");
+		pr_err("Cannot save microcode patches from initrd.\n");
 		goto out;
 	}
 
-- 
1.7.9.5


