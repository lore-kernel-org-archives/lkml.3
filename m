Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKGAuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 19:50:54 -0500
Received: from alexpilon.ca ([69.165.220.233]:57588 "EHLO
	kanataserver.alexpilon.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751122AbaKGAux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 19:50:53 -0500
Date: Thu, 6 Nov 2014 19:50:40 -0500
From: Alex Pilon <alp+linux@alexpilon.ca>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com, trivial@kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH] scsi: mpt2sas: Fix spelling.
Message-ID: <20141107005034.GA8448@alexpilon.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 'ioctl' spelling.

Signed-off-by: Alex Pilon <alp+linux@alexpilon.ca>
---
 drivers/scsi/mpt2sas/mpt2sas_ctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
index fa0567c..7f842c8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
@@ -224,7 +224,7 @@ struct mpt2_ioctl_eventreport {
 };
 
 /**
- * struct mpt2_ioctl_command - generic mpt firmware passthru ioclt
+ * struct mpt2_ioctl_command - generic mpt firmware passthru ioctl
  * @hdr - generic header
  * @timeout - command timeout in seconds. (if zero then use driver default
  *  value).
-- 
2.1.3

