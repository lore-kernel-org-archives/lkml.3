Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbbANIjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:39:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbbANH0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:26:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.18 016/150] iwlwifi: mvm: update values for Smart Fifo
Date: Tue, 13 Jan 2015 23:21:27 -0800
Message-Id: <20150114072056.606551582@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b4c82adcba8cb4b23068a6b800ca98da3bee6888 upstream.

Interoperability issues were identified and root caused to
the Smart Fifo watermarks. These issues arose with
NetGear R7000. Fix this.

Fixes: 1f3b0ff8ecce ("iwlwifi: mvm: Add Smart FIFO support")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1589,7 +1589,7 @@ enum iwl_sf_scenario {
 #define SF_NUM_TIMEOUT_TYPES 2		/* Aging timer and Idle timer */
 
 /* smart FIFO default values */
-#define SF_W_MARK_SISO 4096
+#define SF_W_MARK_SISO 6144
 #define SF_W_MARK_MIMO2 8192
 #define SF_W_MARK_MIMO3 6144
 #define SF_W_MARK_LEGACY 4096


