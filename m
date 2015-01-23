Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbbAWTMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:12:18 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57098 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbAWTMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:12:15 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v1 2/2] Staging: comedi: fix line over 80 characters warning
Date: Sat, 24 Jan 2015 00:41:20 +0530
Message-Id: <1422040280-20213-3-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com>
References: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file jr3_pci.c that fix up warning line
over 80 character which is found by checkpatch tool. Made change into signature
of struct jr3_pci_poll_delay jr3_pci_poll_subdevice function by giving a newline
so that 80 character line over warning to be reduced.

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/jr3_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 81fab2d..1de843d 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -449,7 +449,8 @@ static int jr3_download_firmware(struct comedi_device *dev,
 	return 0;
 }
 
-static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice *s)
+static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice
+							*s)
 {
 	struct jr3_pci_subdev_private *spriv = s->private;
 	struct jr3_pci_poll_delay result = poll_delay_min_max(1000, 2000);
-- 
1.9.1

