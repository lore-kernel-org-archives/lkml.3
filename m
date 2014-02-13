Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBMTrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaBMTrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:48 -0500
Date: Thu, 13 Feb 2014 14:47:38 -0500
Message-Id: <201402131947.s1DJlc7s023072@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 31/38] staging/bcm: formatting cleaning for IOCTL_BCM_IDENTIFY_ACTIVE_SECTION
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 010dd2a56df0..a4a68a9bbd5f 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1940,13 +1940,12 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_set_active_section(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_IDENTIFY_ACTIVE_SECTION: {
+	case IOCTL_BCM_IDENTIFY_ACTIVE_SECTION:
 		/* Right Now we are taking care of only DSD */
 		Adapter->bAllDSDWriteAllow = false;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_IDENTIFY_ACTIVE_SECTION called");
 		Status = STATUS_SUCCESS;
-	}
-	break;
+		break;
 
 	case IOCTL_BCM_COPY_SECTION: {
 		struct bcm_flash2x_copy_section sCopySectStrut = {0};
-- 
1.8.5.3

