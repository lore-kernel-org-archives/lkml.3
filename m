Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaIZRxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:53:15 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58652 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703AbaIZRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:53:13 -0400
Message-ID: <1411753991.7866.69.camel@x220>
Subject: [PATCH] [TRIVIAL] PCI: Fix comment typo 'COMFIG_PM_OPS'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 19:53:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 17:53:11.0979 (UTC) FILETIME=[BD43FFB0:01CFD9B2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Build tested only.

 drivers/pci/pci-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 2b3c89425bb5..3c6ba623c325 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1231,11 +1231,11 @@ static const struct dev_pm_ops pci_dev_pm_ops = {
 
 #define PCI_PM_OPS_PTR	(&pci_dev_pm_ops)
 
-#else /* !COMFIG_PM_OPS */
+#else /* !CONFIG_PM */
 
 #define PCI_PM_OPS_PTR	NULL
 
-#endif /* !COMFIG_PM_OPS */
+#endif /* !CONFIG_PM */
 
 /**
  * __pci_register_driver - register a new pci driver
-- 
1.9.3

