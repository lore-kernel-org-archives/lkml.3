Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3KRS6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:58:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3KRSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11 19/25] iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC series
Date: Mon, 18 Nov 2013 10:40:48 -0800
Message-Id: <20131118184038.138454909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Gottlieb <matti.gottlieb@intel.com>

commit b49926629fb5c324bb1ed3960fb0d7905a4a8562 upstream.

Add some new PCI IDs to the table for 7000 & 3160 series

Cc: stable@vger.kernel.org
Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |   35 +++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -270,54 +270,83 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 #if IS_ENABLED(CONFIG_IWLMVM)
 /* 7000 Series */
 	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4072, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4170, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4060, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x406A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4160, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4062, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4162, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4272, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4260, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x426A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4262, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4470, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4472, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4460, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x446A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4462, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4870, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x486E, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4A70, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4A6E, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4A6C, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4570, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4560, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4370, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4360, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x5070, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4020, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x402A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4220, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4420, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC070, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC072, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC170, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC060, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC06A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC160, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC062, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC162, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC770, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC760, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC272, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC260, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC26A, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC262, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC470, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC472, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC460, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC462, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC570, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC560, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC370, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC360, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC020, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC02A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC220, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC420, iwl7260_2n_cfg)},
 
 /* 3160 Series */
 	{IWL_PCI_DEVICE(0x08B3, 0x0070, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0072, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x0170, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0172, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x0060, iwl3160_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x0062, iwl3160_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B4, 0x0270, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B4, 0x0272, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x0470, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0472, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B4, 0x0370, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8070, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8072, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8170, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8172, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8060, iwl3160_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8062, iwl3160_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B4, 0x8270, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8470, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8570, iwl3160_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}


