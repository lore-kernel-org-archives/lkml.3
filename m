Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaHLCCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:02:16 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44546 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaHLCCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:02:13 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/3] staging: comedi: addi_apci_1564: miscellaneous cleanups
Date: Mon, 11 Aug 2014 21:02:00 -0500
Message-Id: <cover.1407804777.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes an uncorrect and unneeded insn_config operation,
strips out remaining in-driver watchdog subdevice code, and cleans up the
driver's register map defines.

Chase Southwood (3):
  staging: comedi: addi_apci_1564: remove apci1564_do_config
  staging: comedi: addi_apci_1564: Remove in-driver watchdog support
    code
  staging: comedi: addi_apci_1564: tidy register map defines

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 158 +++++++--------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  20 +--
 2 files changed, 60 insertions(+), 118 deletions(-)

-- 
2.0.4

