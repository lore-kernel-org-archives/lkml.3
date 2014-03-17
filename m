Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbaCQNHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:07:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58737 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbaCQNHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:07:16 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-86-5326f3807cc8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ahci_sunxi: make ahci_sunxi_resume() static
Date: Mon, 17 Mar 2014 14:06:57 +0100
Message-id: <1725454.bVvdm9zQru@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jAd3Gz2rBBn8vslq8OT6dyWLT42us
	Fsd2PGKyuLxrDpvF1k17mS1eTnrIavFr+VFGB3aPJ5suMnpsWtXJ5rF5Sb3H+31X2TxaW5az
	enzeJBfAFsVlk5Kak1mWWqRvl8CV8WXNdsaCpawV2xfcZmpgPMnSxcjJISFgInH9yw82CFtM
	4sK99UA2F4eQwCJGiWvTnrNCOC1MElv71zCDVLEJWElMbF/FCGKLCMhKXJn2kBGkiFngCaPE
	gpNbgdo5OIQFHCXur00HqWERUJVY+mA9C0iYV0BT4vftaJCwqICnxI7tK8EW8woISvyYfA/s
	IGYBeYl9+6eyQthaEut3HmeawMg3C0nZLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRHLzPpHYwrmywOMQowMGoxMM7QVktWIg1say4MvcQowQHs5IIr9M7oBBvSmJlVWpR
	fnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGvZvKVuXJyqy/pCL+/v3N
	JO/Kq3PYJJjeZWWv3tOgsftl9o4fQpa3jWM4T1wvOzsnY9/H81LvOG8b+V/Ia9qut6joZt6N
	4p+qZc9+ppvpd3gXdbmZzAhoPskjpDR/6nSXspK/d15yrNWJ6KqL7TDz3lho8tFhdptayXwm
	Lwe2w136gSkpH/iUWIozEg21mIuKEwEVcToOWgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/ahci_sunxi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/ahci_sunxi.c
===================================================================
--- a/drivers/ata/ahci_sunxi.c	2014-03-17 13:59:05.556474489 +0100
+++ b/drivers/ata/ahci_sunxi.c	2014-03-17 13:59:06.220474478 +0100
@@ -209,7 +209,7 @@ disable_resources:
 }
 
 #ifdef CONFIG_PM_SLEEP
-int ahci_sunxi_resume(struct device *dev)
+static int ahci_sunxi_resume(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;

