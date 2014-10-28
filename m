Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaJ1Diq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:38:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaJ1Din (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.17 066/146] iwlwifi: mvm: disable BT Co-running by default
Date: Tue, 28 Oct 2014 11:33:28 +0800
Message-Id: <20141028033346.232767128@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -82,7 +82,7 @@
 #define IWL_MVM_BT_COEX_EN_RED_TXP_THRESH	62
 #define IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH	65
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
-#define IWL_MVM_BT_COEX_CORUNNING		1
+#define IWL_MVM_BT_COEX_CORUNNING		0
 #define IWL_MVM_BT_COEX_MPLUT			1
 
 #endif /* __MVM_CONSTANTS_H */


