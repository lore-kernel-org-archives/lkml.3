Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbbANH0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:26:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbANH0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:26:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.18 017/150] iwlwifi: add new device IDs for 3165
Date: Tue, 13 Jan 2015 23:21:28 -0800
Message-Id: <20150114072056.653476549@linuxfoundation.org>
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

commit 55fd1ce820f461b77919a1997ba8285652219024 upstream.

A few device IDs were added, reflect this change in the
driver.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -367,7 +367,11 @@ static const struct pci_device_id iwl_hw
 
 /* 3165 Series */
 	{IWL_PCI_DEVICE(0x3165, 0x4010, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4012, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4110, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4210, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4410, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4510, iwl3165_2ac_cfg)},
 
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},


