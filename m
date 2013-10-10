Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3JJNjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:39:52 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54514 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JJNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:39:50 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] v4l: tuner-core: fix typo
Date: Thu, 10 Oct 2013 19:09:32 +0530
Message-Id: <1381412372-3772-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/v4l2-core/tuner-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index ddc9379..4b8a9a3 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -247,7 +247,7 @@ static const struct analog_demod_ops tuner_analog_ops = {
 /**
  * set_type - Sets the tuner type for a given device
  *
- * @c:			i2c_client descriptoy
+ * @c:			i2c_client descriptor
  * @type:		type of the tuner (e. g. tuner number)
  * @new_mode_mask:	Indicates if tuner supports TV and/or Radio
  * @new_config:		an optional parameter used by a few tuners to adjust
-- 
1.7.9.5

