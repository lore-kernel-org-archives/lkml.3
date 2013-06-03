Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab3FCR0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:26:44 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62905 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab3FCR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:26:41 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: i2c: add suppport for ths8200 encoder.
Date: Mon,  3 Jun 2013 22:56:16 +0530
Message-Id: <1370280378-2570-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

The first patch of the series adds support for the THS8200 encoder
The full datasheets are available from TI website[1]. The second patch
of the series adds supports for v4l-async subdevice probing.

[1] http://www.ti.com/product/ths8200

Hans Verkuil (1):
  media: i2c: ths8200: driver for TI video encoder.

Lad, Prabhakar (1):
  media: i2c: ths8200: add support v4l-async

 drivers/media/i2c/Kconfig        |    9 +
 drivers/media/i2c/Makefile       |    1 +
 drivers/media/i2c/ths8200.c      |  568 ++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths8200_regs.h |  161 +++++++++++
 4 files changed, 739 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/ths8200.c
 create mode 100644 drivers/media/i2c/ths8200_regs.h

