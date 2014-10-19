Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaJSJ40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:56:26 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53882 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaJSJ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:56:22 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, joe@perches.com,
        giedrius.statkevicius@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 0/2] Staging: rts5208: rtsx_reset_chip style clean up
Date: Sun, 19 Oct 2014 11:55:52 +0200
Message-Id: <1413712554-4872-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code in rtsx_reset_chip function defining two new helper
functions rtsx_reset_aspm and rtsx_enable_pcie_intr.
Specifically, the following checkpatch warnings are corrected:
* PARENTHESIS_ALIGNMENT at rows 271, 302, 343 and 346
* LONG_LINE at rows 294, 313 and 315
* BRACES at rowa 320 and 351
This patch is inspired by the following post on LKML regarding another
clean up for rts5208 module:
http://www.spinics.net/lists/linux-driver-devel/msg55038.html

Fabio Falzoi (2):
  Staging: rts5208: helper function to manage aspm during reset
  Staging: rts5208: helper function to enable interrupts during reset

 drivers/staging/rts5208/rtsx_chip.c | 168 +++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 81 deletions(-)

-- 
2.1.1

