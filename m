Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaGPW0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:26:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55049 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaGPW0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:26:52 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/1] Staging: adl_pci9118: a style issue fixed
Date: Thu, 17 Jul 2014 01:26:23 +0300
Message-Id: <1405549583-11415-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a 'quoted string split across lines' fixed while better use of
English applied to the text.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 93bd9ee..7365f31 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -418,8 +418,7 @@ static int check_channel_list(struct comedi_device *dev,
 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
 			    (bipolar)) {
 				comedi_error(dev,
-					     "Bipolar and unipolar ranges "
-							"can't be mixtured!");
+					     "Bipolar and unipolar ranges can't be mixed!");
 				return 0;
 			}
 			if (!devpriv->usemux && differencial &&
-- 
1.7.10.4

