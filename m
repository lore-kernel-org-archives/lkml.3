Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaKLD2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:28:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaKLBdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.17 259/319] iwlwifi: mvm: BT Coex - update the MPLUT Boost register value
Date: Wed, 12 Nov 2014 10:16:37 +0900
Message-Id: <20141112011035.583751975@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit d14b28fd2c61af0bf310230472e342864d799c98 upstream.

Fixes: 2adc8949efab ("iwlwifi: mvm: BT Coex - fix boost register / LUT values")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/coex.c        |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -301,8 +301,8 @@ static const __le64 iwl_ci_mask[][3] = {
 };
 
 static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x28412201),
-	cpu_to_le32(0x11118451),
+	cpu_to_le32(0x2e402280),
+	cpu_to_le32(0x7711a751),
 };
 
 struct corunning_block_luts {
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -289,8 +289,8 @@ static const __le64 iwl_ci_mask[][3] = {
 };
 
 static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x28412201),
-	cpu_to_le32(0x11118451),
+	cpu_to_le32(0x2e402280),
+	cpu_to_le32(0x7711a751),
 };
 
 struct corunning_block_luts {


