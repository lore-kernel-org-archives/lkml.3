Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaEJQXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 12:23:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43100 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaEJQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 12:23:34 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: ravi23ganiga@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: fixed warnings reported by checkpatch tool on comedi_test.c file
Date: Sat, 10 May 2014 21:53:18 +0530
Message-Id: <1399738998-13461-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to remove warnings
reported by checkpatch tool on
comedi_test.c file

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/staging/comedi/drivers/comedi_test.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index ad5014a..9896a16 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -188,6 +188,7 @@ static void waveform_ai_interrupt(unsigned long arg)
 
 	if (cmd->stop_src == TRIG_COUNT) {
 		unsigned int remaining = cmd->stop_arg - devpriv->ai_count;
+
 		if (num_scans >= remaining) {
 			/* about to finish */
 			num_scans = remaining;
@@ -198,6 +199,7 @@ static void waveform_ai_interrupt(unsigned long arg)
 	for (i = 0; i < num_scans; i++) {
 		for (j = 0; j < cmd->chanlist_len; j++) {
 			unsigned short sample;
+
 			sample = fake_waveform(dev, CR_CHAN(cmd->chanlist[j]),
 					       CR_RANGE(cmd->chanlist[j]),
 					       devpriv->usec_current +
-- 
1.7.10.4

