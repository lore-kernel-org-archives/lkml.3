Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaABRS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:18:26 -0500
Received: from [198.211.127.236] ([198.211.127.236]:37120 "EHLO
	mail.josephb.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaABRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:18:21 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jan 2014 12:18:21 EST
From: Joe Borg <cyborg101010@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cyborg101010@gmail.com
Subject: [PATCH] DAS1800: Fixed typeo.
Date: Thu,  2 Jan 2014 17:10:00 +0000
Message-Id: <1388682600-25443-1-git-send-email-cyborg101010@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed foo * bar should be foo *bar.

Fixed by Joe Borg root@josephb.org
---
 drivers/staging/comedi/drivers/das1800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 1880038..8fb87df 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -462,7 +462,7 @@ static inline uint16_t munge_bipolar_sample(const struct comedi_device *dev,
 	return sample;
 }
 
-static void munge_data(struct comedi_device *dev, uint16_t * array,
+static void munge_data(struct comedi_device *dev, uint16_t *array,
 		       unsigned int num_elements)
 {
 	unsigned int i;
-- 
1.8.5.2

