Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbaJ1HQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:16:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaJ1DoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 056/127] iwlwifi: mvm: disable BT Co-running by default
Date: Tue, 28 Oct 2014 11:34:51 +0800
Message-Id: <20141028033423.330971951@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 9b60bb6d86496af1adc753795de2c12c4499868a upstream.

The tables still contain dummy values.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/constants.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -80,7 +80,7 @@
 #define IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW		25
 #define IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT	64
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
-#define IWL_MVM_BT_COEX_CORUNNING		1
+#define IWL_MVM_BT_COEX_CORUNNING		0
 #define IWL_MVM_BT_COEX_MPLUT			1
 
 #endif /* __MVM_CONSTANTS_H */


