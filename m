Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaEXWXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 18:23:20 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:64705 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaEXWXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 18:23:19 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/3] staging: comedi: addi_apci_1564: prepare for adding Change-of-State interrupt support
Date: Sat, 24 May 2014 17:23:02 -0500
Message-Id: <1400970182-20196-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the required subdevice for supporting DI COS interrupts,
as well as introducing a driver-specific private data struct that will
make the COS interrupt operations much more straightforward and clean.

Chase Southwood (3):
  staging: comedi: addi_apci_1564: add a subdevice for Change-of-State
    interrupt support
  staging: comedi: addi_apci_1564: remove send_sig() use
  staging: comedi: addi_apci_1564: introduce apci1564_private struct

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 200 ++++++++++-----------
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  54 +++---
 2 files changed, 126 insertions(+), 128 deletions(-)

-- 
1.9.0

