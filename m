Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaHHVCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:02:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41399 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbaHHUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oren Givon <oren.givon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 108/259] iwlwifi: update the 7265 series HW IDs
Date: Fri,  8 Aug 2014 13:38:51 -0700
Message-Id: <1407530482-4483-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Givon <oren.givon@intel.com>

commit b3c063ae7279981f7161e63b44f214c62f122b32 upstream.

Add one more 7265 series HW ID.
Edit one existing 7265 series HW ID.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index a9e3655..d408df2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -362,6 +362,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x095B, 0x5210, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5012, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5510, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5400, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x1010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5000, iwl7265_2n_cfg)},
@@ -375,7 +376,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9112, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x9200, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x9200, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9510, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9410, iwl7265_2ac_cfg)},
-- 
1.9.1

