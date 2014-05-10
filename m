Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaEJLkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 07:40:22 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49421 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEJLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 07:40:20 -0400
From: Levente Kurusa <levex@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Levente Kurusa <levex@linux.com>
Subject: [PATCH] staging: rtl8821ae: fix pointer coding style
Date: Sat, 10 May 2014 13:39:32 +0200
Message-Id: <1399721972-7921-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by checkpatch.

Signed-off-by: Levente Kurusa <levex@linux.com>
---

 drivers/staging/rtl8821ae/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index a562aa6..7bbaef7 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -392,7 +392,7 @@ static u8 _rtl_pci_get_pciehdr_offset(struct ieee80211_hw *hw)
 					     pcicfg_addr_port +
 					     (num4bytes << 2));
 		rtl_pci_raw_read_port_ushort(PCI_CONF_DATA,
-					     (u16*)&capability_hdr);
+					     (u16 *)&capability_hdr);
 		/* Found the PCI express capability. */
 		if (capability_hdr.capability_id ==
 		    PCI_CAPABILITY_ID_PCI_EXPRESS)
-- 
1.7.9.5

