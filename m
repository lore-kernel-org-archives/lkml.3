Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaKBWJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:09:49 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44723 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaKBWJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:09:44 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: comedi_bond.c:  Remove unneeded #define
Date: Sun,  2 Nov 2014 23:12:04 +0100
Message-Id: <1414966324-18285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded #define. This was previously included in a patch set
two but patchset one was taken by mistake.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/comedi_bond.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 5d19861..85b2f4a 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -61,8 +61,7 @@ struct bonded_device {
 };
 
 struct comedi_bond_private {
-# define MAX_BOARD_NAME 256
-	char name[MAX_BOARD_NAME];
+	char name[256];
 	struct bonded_device **devs;
 	unsigned ndevs;
 	unsigned nchans;
-- 
1.7.10.4

