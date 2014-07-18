Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422742AbaGRPhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:37:00 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55249 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762141AbaGRP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:13 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Don Fry <pcnet32@frontier.com>
Cc: benoit.taine@lip6.fr, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/25] pcnet32: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:58 +0200
Message-Id: <1405697232-11785-12-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/net/ethernet/amd/pcnet32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 4a8fdc4..e2e3aaf 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -61,7 +61,7 @@ static const char *const version =
 /*
  * PCI device identifiers for "new style" Linux PCI Device Drivers
  */
-static DEFINE_PCI_DEVICE_TABLE(pcnet32_pci_tbl) = {
+static const struct pci_device_id pcnet32_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LANCE_HOME), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LANCE), },
 

