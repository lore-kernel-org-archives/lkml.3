Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaFJUkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:40:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34838 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaFJTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 008/160] iwlwifi: add MODULE_FIRMWARE for 7265
Date: Tue, 10 Jun 2014 12:44:08 -0700
Message-Id: <1402429600-20477-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 08a732f4e4a842f0101e5ea03d79e9d613ffadbe upstream.

It was missing.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 3c34a72..ee02c3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -223,3 +223,4 @@ const struct iwl_cfg iwl7265_n_cfg = {
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
+MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-- 
1.9.1

