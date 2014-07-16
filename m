Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428AbaGPPXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:23:44 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:35837 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938AbaGPPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:23:37 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: adl_pci9118: fractured spelling fixed
Date: Wed, 16 Jul 2014 18:23:00 +0300
Message-Id: <1405524180-11005-3-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405524180-11005-1-git-send-email-asadi.samuel@gmail.com>
References: <1405524180-11005-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a fractured spelling in previous style issue fix mended.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index b2d25f5..f2a2d04 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -412,7 +412,7 @@ static int check_channel_list(struct comedi_device *dev,
 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
 			    (differencial)) {
 				comedi_error(dev,
-					     "Differencial and single ended inputs can't be mixtured!");
+					     "Differential and single ended inputs can't be mixtured!");
 				return 0;
 			}
 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
-- 
1.7.10.4

