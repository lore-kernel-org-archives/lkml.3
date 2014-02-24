Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBXKZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:25:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaBXKZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:25:45 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, abgupta@microsoft.com, haiyangz@microsoft.com,
        jasowang@redhat.com, tomi.valkeinen@ti.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...)
Subject: [PATCH v2 2/5] vmbus: add missing breaks
Date: Mon, 24 Feb 2014 11:25:13 +0100
Message-Id: <1393237516-28545-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
References: <1393237516-28545-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/hv/vmbus_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index b37c91b..2352ae48 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -899,10 +899,12 @@ static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
 		irq = res->data.irq.interrupts[0];
+		break;
 
 	case ACPI_RESOURCE_TYPE_ADDRESS64:
 		hyperv_mmio_start = res->data.address64.minimum;
 		hyperv_mmio_size = res->data.address64.address_length;
+		break;
 	}
 
 	return AE_OK;
-- 
1.8.3.1

