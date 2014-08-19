Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaHSPIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:08:13 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58323 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaHSPGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:06:50 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: comedi: ni_labpc: Alignment should match open parenthesis
Date: Tue, 19 Aug 2014 16:06:30 +0100
Message-Id: <1408460793-29793-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
References: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues "CHECK: Alignment should match open parenthesis".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 4f49d51..7210a04 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -403,7 +403,7 @@ static void labpc_set_ai_convert_period(struct comedi_cmd *cmd,
 }
 
 static unsigned int labpc_ai_scan_period(const struct comedi_cmd *cmd,
-					enum scan_mode mode)
+					 enum scan_mode mode)
 {
 	if (cmd->scan_begin_src != TRIG_TIMER)
 		return 0;
@@ -1149,7 +1149,7 @@ static unsigned int labpc_eeprom_read_status(struct comedi_device *dev)
 }
 
 static int labpc_eeprom_write(struct comedi_device *dev,
-				unsigned int address, unsigned int value)
+			      unsigned int address, unsigned int value)
 {
 	struct labpc_private *devpriv = dev->private;
 	const int write_enable_instruction = 0x6;
-- 
2.0.4

