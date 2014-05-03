Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaECHyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 03:54:36 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:42080 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaECHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 03:54:35 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/4] staging: comedi: addi_apci_1564: Further cleanups
Date: Sat,  3 May 2014 02:54:21 -0500
Message-Id: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest patchset in a continuing cleanup of addi_apci_1564.c.  Main focus
is on the auto_attach() function, but also cleaning up some of the old addi
common code wrappers.

To be applied on top of my prior patchset to this file (the one beginning
with [PATCH 1/6] staging: comedi: addi_apci_1564: remove eeprom support code)

Chase Southwood (4):
  staging: comedi: addi_apci_1564: board has 32 digital outputs
  staging: comedi: addi_apci_1564: don't allocate unused subdevices
  staging: comedi: addi_apci_1564: absorb apci1564_reset()
  staging: comedi: addi_apci_1564: call apci1564_interrupt() directly

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 32 -------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 98 ++++++++++------------
 2 files changed, 45 insertions(+), 85 deletions(-)

-- 
1.9.0

