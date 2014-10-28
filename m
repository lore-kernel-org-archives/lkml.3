Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbaJ1H1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:27:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaJ1Dmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:42:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Ahmad <josef.ahmad@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.16 012/127] pci_ids: Add support for Intel Quark ILB
Date: Tue, 28 Oct 2014 11:34:07 +0800
Message-Id: <20141028033421.450902802@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Ahmad <josef.ahmad@intel.com>

commit bb048713bba3ead39f6112910906d9fe3f88ede7 upstream.

This patch adds the PCI id for Intel Quark ILB.
It will be used for GPIO and Multifunction device driver.

Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pci_ids.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2555,6 +2555,7 @@
 #define PCI_DEVICE_ID_INTEL_MFD_EMMC0	0x0823
 #define PCI_DEVICE_ID_INTEL_MFD_EMMC1	0x0824
 #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
+#define PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB	0x095E
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
 #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60


