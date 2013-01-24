Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3AXBQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:16:32 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58944
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3AXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:16:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/6] Drivers: net: hyperv: Use the consolidated GUID definition
Date: Wed, 23 Jan 2013 17:42:42 -0800
Message-Id: <1358991765-22715-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358991765-22715-1-git-send-email-kys@microsoft.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the consolidated GUID definitions in the Hyper-V network driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index a9975c7..329c989 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -498,8 +498,7 @@ static int netvsc_remove(struct hv_device *dev)
 
 static const struct hv_vmbus_device_id id_table[] = {
 	/* Network guid */
-	{ VMBUS_DEVICE(0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
-		       0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E) },
+	{ HV_NIC_GUID, },
 	{ },
 };
 
-- 
1.7.4.1

