Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaB0QeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:34:04 -0500
Received: from vivithemage.co.uk ([213.138.103.165]:45489 "EHLO
	mail.mage.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaB0QeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:34:01 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 11:34:01 EST
From: Reza Snowdon <rs@mage.me.uk>
To: gregkh@linuxfoundation.org
Cc: speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Reza Snowdon <rs@mage.me.uk>
Subject: [PATCH] Staging: speakup: buffers: Fixed a return value coding style issue.
Date: Thu, 27 Feb 2014 16:26:42 +0000
Message-Id: <1393518402-24860-1-git-send-email-rs@mage.me.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Reza Snowdon <rs@mage.me.uk>
---
 drivers/staging/speakup/buffers.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/buffers.c b/drivers/staging/speakup/buffers.c
index 382973e..8d7caa7 100644
--- a/drivers/staging/speakup/buffers.c
+++ b/drivers/staging/speakup/buffers.c
@@ -55,7 +55,8 @@ static int synth_buffer_free(void)
 
 int synth_buffer_empty(void)
 {
-	return (buff_in == buff_out);
+	int buff_comparison = (buff_in == buff_out);
+	return buff_comparison;
 }
 EXPORT_SYMBOL_GPL(synth_buffer_empty);
 
-- 
1.7.10.4

