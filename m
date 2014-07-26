Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaGZTGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:06:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaGZTDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oren Givon <oren.givon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 23/87] iwlwifi: update the 7265 series HW IDs
Date: Sat, 26 Jul 2014 12:01:57 -0700
Message-Id: <20140726190215.279638193@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Givon <oren.givon@intel.com>

commit b3c063ae7279981f7161e63b44f214c62f122b32 upstream.

Add one more 7265 series HW ID.
Edit one existing 7265 series HW ID.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -366,6 +366,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x095A, 0x5012, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5412, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5510, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5400, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x1010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5000, iwl7265_2n_cfg)},
@@ -379,7 +380,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9112, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x9200, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x9200, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9510, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9410, iwl7265_2ac_cfg)},


