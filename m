Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaGKEBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:01:41 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:42656 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaGKEBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:01:40 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/4] staging: comedi: addi_apci_1564: small fixes in apci1564_auto_attach() and apci1564_detach()
Date: Thu, 10 Jul 2014 23:00:54 -0500
Message-Id: <cover.1405050794.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small patchset containing a handful of fixes to the ADDI-DATA
APCI1564 driver that I would like to get out of the way before I forget
to take care of them.  From here, I will move to start fixing the
digital input/timer/counters/watchdog functionality of the board.

Chase Southwood (4):
  staging: comedi: addi_apci_1564: remove len_chanlist from di and do
    subdevices
  staging: comedi: addi_apci_1564: remove unnecessary dev->board_name
    initialization
  staging: comedi: addi_apci_1564: remove null check of devpriv in
    apci1564_detach()
  staging: comedi: addi_apci_1564: fix s->maxdata assignment in do
    subdevice init.

 drivers/staging/comedi/drivers/addi_apci_1564.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

-- 
2.0.1

