Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3HNKhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759865Ab3HNKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 33/75] iwlwifi: add DELL SKU for 5150 HMC
Date: Wed, 14 Aug 2013 11:36:22 +0100
Message-Id: <1376476624-10011-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a1923f1d4723e5757cefdd60f7c7ab30e472007a upstream.

This SKU was missing in the list of supported devices

https://bugzilla.kernel.org/show_bug.cgi?id=60577

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5:
  - file rename: drivers/net/wireless/iwlwifi/pcie/drv.c ->
    drivers/net/wireless/iwlwifi/iwl-pci.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index f482515..2b425da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -131,6 +131,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half Mini Card */
 	{IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini Card */
 	{IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1326, iwl5150_abg_cfg)}, /* Half Mini Card */
 
 	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini Card */
 	{IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini Card */
-- 
1.8.3.2

