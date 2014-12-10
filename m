Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbaLJIAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:00:42 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63665 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaLJIAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:00:41 -0500
Date: Wed, 10 Dec 2014 10:00:36 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma: imx-sdma: fix indentation
Message-ID: <20141210080035.GA25812@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, switch and case should be at the same indent

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/dma/imx-sdma.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 88afc48..8729877 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1301,15 +1301,15 @@ static void sdma_load_firmware(const struct firmware *fw, void *context)
 	if (header->ram_code_start + header->ram_code_size > fw->size)
 		goto err_firmware;
 	switch (header->version_major) {
-		case 1:
-			sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1;
-			break;
-		case 2:
-			sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2;
-			break;
-		default:
-			dev_err(sdma->dev, "unknown firmware version\n");
-			goto err_firmware;
+	case 1:
+		sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1;
+		break;
+	case 2:
+		sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2;
+		break;
+	default:
+		dev_err(sdma->dev, "unknown firmware version\n");
+		goto err_firmware;
 	}
 
 	addr = (void *)header + header->script_addrs_start;
-- 
1.7.0.4

