Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3KYNxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:53:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58885 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab3KYNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:34 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.371780553@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 44/87] iwlwifi: one more sku added to 6x35 series
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 259653d86b80ed01c70d47b7307140ae0ba19420 upstream.

Add new sku to 6x35 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -339,6 +339,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},

