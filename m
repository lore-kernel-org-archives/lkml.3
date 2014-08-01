Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaHABzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:55:54 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39891 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaHABzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:55:52 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/2] staging: comedi: addi_apci_1564: provide interface to read diagnostic status
Date: Thu, 31 Jul 2014 20:55:37 -0500
Message-Id: <cover.1406857380.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset creates a simple subdevice to allow for reading of the
board's diagnostic status, and then removes any code which is related to
diagnostic interrupts, as the driver will not support these at this time.

Chase Southwood (2):
  staging: comedi: addi_apci_1564: add subdevice to check diagnostic
    status
  staging: comedi: addi_apci_1564: remove diagnostic interrupt support
    code

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 14 --------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 41 ++++++++++++----------
 2 files changed, 22 insertions(+), 33 deletions(-)

-- 
2.0.3

