Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaJ2V62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:58:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44076 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbaJ2V61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:58:27 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, dan.carpenter@oracle.com, joe@perches.com,
        giedrius.statkevicius@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 0/2] Staging: rts5208: rtsx_reset_chip style clean up
Date: Wed, 29 Oct 2014 22:58:17 +0100
Message-Id: <1414619899-2633-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code in rtsx_reset_chip function defining two new helper
functions rtsx_reset_aspm and rtsx_enable_pcie_intr.
Specifically, the following checkpatch warnings are corrected:

* PARENTHESIS_ALIGNMENT at rows 295 and 313

This patch is inspired by the following post on LKML regarding another
clean up for rts5208 module:
http://www.spinics.net/lists/linux-driver-devel/msg55038.html

Changes in v3:
* rebased against master branch of linux-next tree

Changes in v2:
* rebased against staging-testing branch of staging driver development
tree

Fabio Falzoi (2):
  Staging: rts5208: helper function to manage aspm during reset
  Staging: rts5208: helper function to enable interrupts

 drivers/staging/rts5208/rtsx_chip.c | 165 +++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 78 deletions(-)

-- 
2.1.1

