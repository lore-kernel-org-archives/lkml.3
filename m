Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaEGHDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:03:01 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41480 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaEGHDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:03:00 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/2] staging: comedi: addi_apci_1564: remove boardinfo
Date: Wed,  7 May 2014 02:02:43 -0500
Message-Id: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes the last dependency on this driver's boardinfo (the
timer subdevice init), and then removes the boardinfo from the driver.

To be applied on top of my prior patchset "staging: comedi:
addi_apci_1564: further cleanups"

Chase Southwood (2):
  staging: comedi: addi_apci_1564: remove check for timer subdevice
  staging: comedi: addi_apci_1564: remove boardinfo

 drivers/staging/comedi/drivers/addi_apci_1564.c | 40 +++++++------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

-- 
1.9.0

