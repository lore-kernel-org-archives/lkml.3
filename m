Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaACCkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:40:19 -0500
Received: from nm23-vm2.bullet.mail.gq1.yahoo.com ([98.136.217.81]:42376 "EHLO
	nm23-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbaACCkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:40:17 -0500
X-Yahoo-Newman-Id: 981726.30425.bm@smtp216.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lq9ICtwVM1kEWjYx67Q8PmvVCWFcVoEcItxlP7qeWHYcTVF
 FUmtS10yGPu5Gx6_J4fjrayOMGU8ZT6Hq8foAOfZvB_BvORtupzq8_J2aMfC
 jOKG.LiPPe65m7ib1LA4m_u7pBq5k5SWrIee4xUicw9hOBzUXBO.NQb9u8H8
 AXZQo1DxmsVFisXiJ0dU62VYTXEkwCFxsRpB4RuEAiIyqwEijh0BTY0srWei
 U2.1opklpawUDS3e1F4OaueXYKxSbXRg5DUU1Udd4HEngWTL4dxAFCgVqbcf
 R7I.elF3bSMv0cRnk0Qpu8WkKnCuhCjfAS2FOhP972Z6PLlwlhwppBe89gkn
 c2cwzRE6bb_MIAWXhr4qd7VSRASVADwG6n6q2pNPIVlhd53NLNyh0LTxnF..
 mB9Vh94OrMdlv6kvFZXQkbpZO11h0q0JrMfWbyJO_gZSkvT61HmicnjMsllJ
 NMVfoQdHrFCsptZOVVExQLEP8l9Bz6aOzCLw1t4S5LUFPH6cjcdRyB4iHB4k
 T9v76BwWU7ggdvFfy5XXvo9l5PSHs.eMrtdEz2ITe7_gWff4-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.139.211.125])
        by smtp216.mail.gq1.yahoo.com with SMTP; 03 Jan 2014 02:40:16 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: hsweeten@visionengravers.com, devel@driverdevel.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: fix spacing/style problem in das1800.c
Date: Thu,  2 Jan 2014 20:40:04 -0600
Message-Id: <1388716804-15348-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes a style issue found by
checkpatch.pl.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/das1800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 165bdfd..320d95a 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -459,7 +459,7 @@ static inline uint16_t munge_bipolar_sample(const struct comedi_device *dev,
 	return sample;
 }
 
-static void munge_data(struct comedi_device *dev, uint16_t * array,
+static void munge_data(struct comedi_device *dev, uint16_t *array,
 		       unsigned int num_elements)
 {
 	unsigned int i;
-- 
1.8.4.2

