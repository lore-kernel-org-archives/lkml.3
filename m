Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543AbaKLBn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:43:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbaKLBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 115/203] x86, iosf: Add Quark X1000 PCI ID
Date: Wed, 12 Nov 2014 10:16:25 +0900
Message-Id: <20141112011547.949147623@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ong Boon Leong <boon.leong.ong@intel.com>

commit 90916e048c1e0c1d379577e43ab9b8e331490cfb upstream.

Add PCI device ID, i.e. that of the Host Bridge,
for IOSF MBI driver.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-4-git-send-email-david.e.box@linux.intel.com
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/iosf_mbi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -201,6 +201,7 @@ static int iosf_mbi_probe(struct pci_dev
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0958) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);


