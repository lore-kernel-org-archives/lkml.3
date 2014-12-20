Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaLTQdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:33:33 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46273 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaLTQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:33:29 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: arm: cumana_1.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:36:15 +0100
Message-Id: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function cumanascsi_setup() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/arm/cumana_1.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 8ef810a..7c90d9c 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -38,10 +38,6 @@
 
 #include "../NCR5380.h"
 
-void cumanascsi_setup(char *str, int *ints)
-{
-}
-
 const char *cumanascsi_info(struct Scsi_Host *spnt)
 {
 	return "";
-- 
1.7.10.4

