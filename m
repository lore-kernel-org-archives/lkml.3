Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaJ0TWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:22:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaJ0TCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oren Givon <oren.givon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/105] iwlwifi: Add missing PCI IDs for the 7260 series
Date: Mon, 27 Oct 2014 11:55:56 -0700
Message-Id: <1414436240-13879-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Givon <oren.givon@intel.com>

commit 4f08970f5284dce486f0e2290834aefb2a262189 upstream.

Add 4 missing PCI IDs for the 7260 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index d408df2..d9bb9b8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -272,6 +272,8 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4072, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4170, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4C60, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4C70, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4060, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x406A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4160, iwl7260_2n_cfg)},
@@ -312,6 +314,8 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B1, 0xC770, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC760, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xCC70, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xCC60, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC272, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC260, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC26A, iwl7260_n_cfg)},
-- 
1.9.1

