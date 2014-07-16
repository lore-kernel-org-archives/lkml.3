Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbaGPMZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:25:04 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:33040 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPMZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:25:02 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH] Staging: comedi: adl_pci9118: a style issue fixed
Date: Wed, 16 Jul 2014 15:24:12 +0300
Message-Id: <1405513452-7628-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
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
