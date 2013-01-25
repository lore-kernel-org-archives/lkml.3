Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3AYHB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:01:27 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34210 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3AYHB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:01:26 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 0/2] TVP7002 add support for media controller based usag
Date: Fri, 25 Jan 2013 12:31:06 +0530
Message-Id: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

The first patch adds a entry MEDIA_ENT_T_V4L2_SUBDEV_DECODER for decoders
and second patch adds media controller support for tvp7002 decoder.

Manjunath Hadli (2):
  media: add support for decoder subdevs along with sensor and others
  media: tvp7002: enable TVP7002 decoder for media controller based
    usage

 drivers/media/i2c/tvp7002.c |  132 +++++++++++++++++++++++++++++++++++++++++-
 include/media/tvp7002.h     |    2 +
 include/uapi/linux/media.h  |    1 +
 3 files changed, 131 insertions(+), 4 deletions(-)

-- 
1.7.4.1

