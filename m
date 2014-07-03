Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaGCCQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:16:22 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50582 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaGCCQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:16:20 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 0/3] staging: comedi: addi_apci_1564: miscellaneous fixes and cleanups
Date: Wed,  2 Jul 2014 21:15:39 -0500
Message-Id: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
References: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
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
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 139 +++++----------------
 2 files changed, 32 insertions(+), 109 deletions(-)

-- 
2.0.1

