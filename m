Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaBUI5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:57:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbaBUI5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:57:08 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, haiyangz@microsoft.com, jasowang@redhat.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...)
Subject: [PATCH 2/4] vmbus: add missing breaks
Date: Fri, 21 Feb 2014 09:56:42 +0100
Message-Id: <1392973004-28215-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1392973004-28215-1-git-send-email-kraxel@redhat.com>
References: <1392973004-28215-1-git-send-email-kraxel@redhat.com>
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

