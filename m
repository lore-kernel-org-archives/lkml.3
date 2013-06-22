Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3FVRo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 13:44:26 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61740 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3FVRoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:44:25 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 0/2] media: i2c: tvp7002: feature enhancement
Date: Sat, 22 Jun 2013 23:14:13 +0530
Message-Id: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

The first patch of the series add support for asynchronous probing
and the second patch adds OF support to tvp7002 driver.

Lad, Prabhakar (2):
  media: i2c: tvp7002: add support for asynchronous probing
  media: i2c: tvp7002: add OF support

 .../devicetree/bindings/media/i2c/tvp7002.txt      |   43 ++++++++++++
 drivers/media/i2c/tvp7002.c                        |   73 ++++++++++++++++++--
 2 files changed, 109 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt

-- 
1.7.9.5

