Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaE1VZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:25:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaE1VZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:25:14 -0400
Date: Wed, 28 May 2014 14:25:03 -0700
From: tip-bot for Ong Boon Leong <tipbot@zytor.com>
Message-ID: <tip-90916e048c1e0c1d379577e43ab9b8e331490cfb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boon.leong.ong@intel.com, david.e.box@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, david.e.box@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1399668248-24199-4-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-4-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, iosf: Add Quark X1000 PCI ID
Git-Commit-ID: 90916e048c1e0c1d379577e43ab9b8e331490cfb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90916e048c1e0c1d379577e43ab9b8e331490cfb
Gitweb:     http://git.kernel.org/tip/90916e048c1e0c1d379577e43ab9b8e331490cfb
Author:     Ong Boon Leong <boon.leong.ong@intel.com>
AuthorDate: Fri, 9 May 2014 13:44:07 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 May 2014 14:57:23 -0700

x86, iosf: Add Quark X1000 PCI ID

Add PCI device ID, i.e. that of the Host Bridge,
for IOSF MBI driver.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-4-git-send-email-david.e.box@linux.intel.com
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/iosf_mbi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index f4ff978..201a7ab 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -201,6 +201,7 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0958) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);
