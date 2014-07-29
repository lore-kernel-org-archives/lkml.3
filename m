Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaG2MBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:01:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51667 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbaG2L6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:48 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] staging: comedi: amplc_pci230: remove some indentation in pci230_ai_check_chanlist()
Date: Tue, 29 Jul 2014 12:58:22 +0100
Message-Id: <1406635107-27950-15-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few lines in `pci230_ai_check_chanlist()` are indented one level too
much, so remove the excess indentation.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index df58679..c2da10c 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1603,10 +1603,10 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 
 			if (subseq_len > 0 &&
 			    cmd->chanlist[i % subseq_len] != chanspec) {
-					dev_dbg(dev->class_dev,
-						"%s: channel numbers must increase or sequence must repeat exactly\n",
-						__func__);
-					return -EINVAL;
+				dev_dbg(dev->class_dev,
+					"%s: channel numbers must increase or sequence must repeat exactly\n",
+					__func__);
+				return -EINVAL;
 			}
 
 			if (aref != prev_aref) {
-- 
2.0.0

