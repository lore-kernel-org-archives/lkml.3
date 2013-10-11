Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3JKTmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:42:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab3JKTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [ 101/135] usb: chipidea: add Intel Clovertrail pci id
Date: Fri, 11 Oct 2013 12:39:42 -0700
Message-Id: <20131011193956.229251947@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit a214339d764a07b99dc0418685d6cc8a0a1970d5 upstream.

Also clean up the last item of the pci id list to be "cleaner".

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_pci.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_pci.c
+++ b/drivers/usb/chipidea/ci_hdrc_pci.c
@@ -129,7 +129,12 @@ static DEFINE_PCI_DEVICE_TABLE(ci_hdrc_p
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0829),
 		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
 	},
-	{ 0, 0, 0, 0, 0, 0, 0 /* end: all zeroes */ }
+	{
+		/* Intel Clovertrail */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe006),
+		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
+	},
+	{ 0 } /* end: all zeroes */
 };
 MODULE_DEVICE_TABLE(pci, ci_hdrc_pci_id_table);
 


