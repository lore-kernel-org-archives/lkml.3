Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3IYBJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:09:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab3IYAQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [ 049/110] pci_ids: Add PCI device ID functions 3 and 4 for newer F15h models.
Date: Tue, 24 Sep 2013 17:14:47 -0700
Message-Id: <20130925001328.707925706@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

commit 6bdaa63c2957ac04e8d596880f732b79f9c06c3c upstream.

Add PCI device IDs for AMD F15h, model 30h. They will be used in
amd_nb.c and amd64_edac.c

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,8 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
 #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602


