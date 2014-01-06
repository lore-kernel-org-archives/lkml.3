Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaAFDxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:53:03 -0500
Received: from nm1-vm4.bullet.mail.gq1.yahoo.com ([98.136.218.83]:37790 "EHLO
	nm1-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbaAFDxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:53:00 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2014 22:53:00 EST
X-Yahoo-Newman-Id: 451441.44692.bm@smtp209.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: D1PwJGEVM1lGZhPkgRTcMzi88Euvbzp.cEVyuN0O6OynqAk
 2e1W9cCPbRtFh20T8dFWtDf1OatbAhuqJ08qC6RsvU3r0UzY_.PdTUDOpyq9
 gs_BMXa42qKJYVp8NGxe6mnRPN4YYu4vVi.MHg7wKU_aNmod8GbyDtHVbNib
 rR3oD824t..VlK6WTj05C7zm4BDZ3eKBM.3kklQe3MvTS78gVPB6UU2S0nbM
 o9ZT57v7JfttuZsFjaiLn8JarkPrHTqq1yDKCBrzcQCA9UbqJPPYlHzUXjab
 CxTAbiRitwgQnwRQZG316hkO8q9.EqCeFEkdN79Zx1UKJF1oikuQg6Ftnlf7
 PhFQl2sJHArxIJ2bJXSXGJ6ts2Q4oCzoTlhKZyRu9YQ1anRB9H56BpoFE5lg
 xBr8TZhTC_8FE_eW9sDbg6.pD5eA6osPhEBCsId8V4hCeUlQvcH0GyMTsVjU
 lsyJ58Q7hysPnl19m55qMS1cVTakKNJ2lKXMq.bIlX_MKCj0jBLhMGhyJJzB
 .7hgr9n0CG.mdH4Hqj4YSBWowwd4CdQ--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.139.211.125])
        by smtp209.mail.gq1.yahoo.com with SMTP; 05 Jan 2014 19:47:00 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, trivial@kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2] Staging: comedi: fix spacing/style problem in das1800.c (and das6402.c)
Date: Sun,  5 Jan 2014 21:46:54 -0600
Message-Id: <1388980014-5416-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a style issue regarding asterisk placement in
das1800.c and das6402.c found by checkpatch.pl.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Added fix for identical style problem in das6402.c, previous version only changed das1800.c.

 drivers/staging/comedi/drivers/das1800.c | 2 +-
 drivers/staging/comedi/drivers/das6402.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index e80c19a8..43027ee 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -202,7 +202,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 
 #ifdef unused
 static int das6402_ai_mode2(struct comedi_device *dev,
-			    struct comedi_subdevice *s, comedi_trig * it)
+			    struct comedi_subdevice *s, comedi_trig *it)
 {
 	struct das6402_private *devpriv = dev->private;
 
-- 
1.8.4.2

