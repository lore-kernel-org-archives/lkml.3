Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3ENFpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:45:39 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36253 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3ENFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:45:37 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, ivtv-devel@ivtvdriver.org
Cc: linux-kernel@vger.kernel.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Andy Walls <awalls@md.metrocast.net>,
        Mike Isely <isely@pobox.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Martin Bugge <marbugge@cisco.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Janne Grunau <j@jannau.net>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/4] media: remove duplicate check for EPERM
Date: Tue, 14 May 2013 11:15:13 +0530
Message-Id: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series cleanups the check for EPERM in dbg_g/s_register
and vidioc_g/s_register.

Lad, Prabhakar (4):
  media: i2c: remove duplicate checks for EPERM in dbg_g/s_register
  media: dvb-frontends: remove duplicate checks for EPERM in
    dbg_g/s_register
  media: usb: remove duplicate checks for EPERM in vidioc_g/s_register
  media: pci: remove duplicate checks for EPERM

 drivers/media/dvb-frontends/au8522_decoder.c |    4 ----
 drivers/media/i2c/ad9389b.c                  |    4 ----
 drivers/media/i2c/adv7183.c                  |    4 ----
 drivers/media/i2c/adv7604.c                  |    4 ----
 drivers/media/i2c/cs5345.c                   |    4 ----
 drivers/media/i2c/cx25840/cx25840-core.c     |    4 ----
 drivers/media/i2c/m52790.c                   |    4 ----
 drivers/media/i2c/mt9v011.c                  |    4 ----
 drivers/media/i2c/ov7670.c                   |    4 ----
 drivers/media/i2c/saa7115.c                  |    4 ----
 drivers/media/i2c/saa7127.c                  |    4 ----
 drivers/media/i2c/saa717x.c                  |    4 ----
 drivers/media/i2c/ths7303.c                  |    4 ----
 drivers/media/i2c/tvp5150.c                  |    4 ----
 drivers/media/i2c/tvp7002.c                  |   10 ++--------
 drivers/media/i2c/upd64031a.c                |    4 ----
 drivers/media/i2c/upd64083.c                 |    4 ----
 drivers/media/i2c/vs6624.c                   |    4 ----
 drivers/media/pci/bt8xx/bttv-driver.c        |    6 ------
 drivers/media/pci/cx18/cx18-av-core.c        |    4 ----
 drivers/media/pci/cx23885/cx23885-ioctl.c    |    6 ------
 drivers/media/pci/cx23885/cx23888-ir.c       |    4 ----
 drivers/media/pci/ivtv/ivtv-ioctl.c          |    2 --
 drivers/media/pci/saa7146/mxb.c              |    4 ----
 drivers/media/pci/saa7164/saa7164-encoder.c  |    6 ------
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |    2 --
 26 files changed, 2 insertions(+), 110 deletions(-)

-- 
1.7.4.1

