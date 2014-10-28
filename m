Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbaJ1Dsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:48:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaJ1Dsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:48:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oren Givon <oren.givon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 043/100] iwlwifi: Add missing PCI IDs for the 7260 series
Date: Tue, 28 Oct 2014 11:35:28 +0800
Message-Id: <20141028033502.549751261@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Givon <oren.givon@intel.com>

commit 4f08970f5284dce486f0e2290834aefb2a262189 upstream.

Add 4 missing PCI IDs for the 7260 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -272,6 +272,8 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4072, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4170, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4C60, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4C70, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4060, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x406A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4160, iwl7260_2n_cfg)},
@@ -315,6 +317,8 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x08B1, 0xC770, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC760, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xCC70, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xCC60, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC272, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC260, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC26A, iwl7260_n_cfg)},


