Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413AbaGPPXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:23:34 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:43388 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938AbaGPPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:23:32 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/2] Staging: comedi: adl_pci9118: a style issue fixed
Date: Wed, 16 Jul 2014 18:22:59 +0300
Message-Id: <1405524180-11005-2-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405524180-11005-1-git-send-email-asadi.samuel@gmail.com>
References: <1405524180-11005-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'quoted string split across lines' warning in checkpatching fixed
by group whole string in one line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 59a65cb..b2d25f5 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -412,8 +412,7 @@ static int check_channel_list(struct comedi_device *dev,
 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
 			    (differencial)) {
 				comedi_error(dev,
-					     "Differencial and single ended "
-						"inputs can't be mixtured!");
+					     "Differencial and single ended inputs can't be mixtured!");
 				return 0;
 			}
 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
-- 
1.7.10.4

