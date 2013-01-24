Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3AXBQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:16:19 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41109
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab3AXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:16:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/6] Drivers: hid: hid-hyperv: Use consolidated GUID definitions
Date: Wed, 23 Jan 2013 17:42:44 -0800
Message-Id: <1358991765-22715-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358991765-22715-1-git-send-email-kys@microsoft.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the consolidated GUID definitions in the Hyper-V mouse driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hid/hid-hyperv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 3d62781..aa3fec0 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -568,8 +568,7 @@ static int mousevsc_remove(struct hv_device *dev)
 
 static const struct hv_vmbus_device_id id_table[] = {
 	/* Mouse guid */
-	{ VMBUS_DEVICE(0x9E, 0xB6, 0xA8, 0xCF, 0x4A, 0x5B, 0xc0, 0x4c,
-		       0xB9, 0x8B, 0x8B, 0xA1, 0xA1, 0xF3, 0xF9, 0x5A) },
+	{ HV_MOUSE_GUID, },
 	{ },
 };
 
-- 
1.7.4.1

