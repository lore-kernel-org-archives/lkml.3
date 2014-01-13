Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaAMVsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:48:09 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53963 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:48:07 -0500
From: Joe Borg <cyborg101010@gmail.com>
To: gregkh@linuxfoundation.org
Cc: cyborg101010@gmail.com, abbotti@mev.co.uk, hsweeten@visionengravers.com,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] DAS1800: Fixing foo * bar should be foo *bar
Date: Mon, 13 Jan 2014 21:47:59 +0000
Message-Id: <1389649679-19605-1-git-send-email-cyborg101010@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed an error flagged by checkpatch.pl, 'foo * bar should be foo *bar' in the parameters of function munge_data().

Signed-off-by Joe Borg <cyborg101010@gmail.com>
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

