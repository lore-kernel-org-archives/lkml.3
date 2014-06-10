Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaFJUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:38:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaFJTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oren Givon <oren.givon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/160] iwlwifi: add new 7265 HW IDs
Date: Tue, 10 Jun 2014 12:44:06 -0700
Message-Id: <1402429600-20477-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Givon <oren.givon@intel.com>

commit 80f2679e589503bd6cbaaa1f9c1cd9dd7dfae032 upstream.

Add 2 new HW IDs for the 7265 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index db7c0c7..a9e3655 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -368,12 +368,14 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x095A, 0x500A, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5200, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5002, iwl7265_n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5102, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5202, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9012, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9112, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9200, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9510, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9410, iwl7265_2ac_cfg)},
-- 
1.9.1

