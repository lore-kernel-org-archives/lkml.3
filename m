Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3H0B0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:26:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3H0BG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 15/74] iwlwifi: bump required firmware API version for 3160/7260
Date: Mon, 26 Aug 2013 18:08:13 -0700
Message-Id: <20130827010427.714126149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a2d0909a687b4d250cc2b7481072e361678745ba upstream.

As the firmware API has changed significantly and we don't
have support code for the old APIs, bump the version to be
able to release the version 7 API firmware. Unfortunately
this means that the driver in 3.9 and 3.10 can't work, but
that's still better than crashing the device/driver there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-7000.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,16 +67,16 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	6
-#define IWL3160_UCODE_API_MAX	6
+#define IWL7260_UCODE_API_MAX	7
+#define IWL3160_UCODE_API_MAX	7
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	6
-#define IWL3160_UCODE_API_OK	6
+#define IWL7260_UCODE_API_OK	7
+#define IWL3160_UCODE_API_OK	7
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	6
-#define IWL3160_UCODE_API_MIN	6
+#define IWL7260_UCODE_API_MIN	7
+#define IWL3160_UCODE_API_MIN	7
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d


