Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbaF1Esf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 00:48:35 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:53412 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaF1Ese (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 00:48:34 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/3] staging: comedi: addi_apci_1564: miscellaneous fixes and cleanups
Date: Fri, 27 Jun 2014 23:47:56 -0500
Message-Id: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves a misplaced include to the proper file, swaps out an overly
aggressive placement of apci1564_reset(), and cleans up apci1564_interrupt().

Chase Southwood (3):
  staging: comedi: addi_apci_1564: move addi_watchdog.h include to
    addi_apci_1564.c
  staging: comedi: addi_apci_1564: fix use of apci1564_reset() to
    disable DI interrupts
  staging: comedi: addi_apci_1564: clean up apci1564_interrupt()

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |   2 -
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 114 +++++----------------
 2 files changed, 28 insertions(+), 88 deletions(-)

-- 
2.0.1

