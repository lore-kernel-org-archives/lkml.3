Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab3BVSGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:06:49 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65252 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab3BVSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:06:48 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 0/2] [comedi] fix for DMA buffers on stack
Date: Fri, 22 Feb 2013 10:06:30 -0800
Message-Id: <1361556392-32501-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes couple of instances of DMA buffers on stack(being passed
to usb_control_msg) for comedi USB drivers. Found using smatch.

Kumar Amit Mehta (2):
  staging: comedi: drivers: usbdux.c: fix DMA buffers on stack
  staging: comedi: drivers: usbduxfast.c: fix for DMA buffers on stack

 drivers/staging/comedi/drivers/usbdux.c     |   31 ++++++++++++++++-----------
 drivers/staging/comedi/drivers/usbduxfast.c |   30 +++++++++++++++-----------
 2 files changed, 37 insertions(+), 24 deletions(-)

-- 
1.7.9.5

