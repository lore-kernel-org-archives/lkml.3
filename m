Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3ETLEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:04:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56302 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3ETKxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shuduo Sang <sangshuduo@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 080/115] iwlwifi: add new pci id for 6x35 series
Date: Mon, 20 May 2013 11:51:20 +0100
Message-Id: <1369047116-9378-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuduo Sang <sangshuduo@gmail.com>

commit 20ecf9fd3bebc4147e2996c08a75d6f0229b90df upstream.

some new thinkpad laptops use intel chip with new pci id need be added
lspci -vnn output:
 Network controller [0280]: Intel Corporation Centrino Advanced-N 6235
 [8086:088f] (rev 24)
 Subsystem: Intel Corporation Device [8086:5260]

Signed-off-by: Shuduo Sang <sangshuduo@gmail.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backport to 3.5:
  - file rename: iwlwifi/pcie/drv.c -> iwlwifi/iwl-pci.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 0c8a1c2..f482515 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -243,6 +243,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
-- 
1.8.1.2

