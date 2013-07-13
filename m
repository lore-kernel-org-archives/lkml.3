Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3GMIup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:50:45 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55964 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab3GMIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:50:43 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/5] Davinci VPBE use devres and some cleanup
Date: Sat, 13 Jul 2013 14:20:26 +0530
Message-Id: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series replaces existing resource handling in the
driver with managed device resource.

Lad, Prabhakar (5):
  media: davinci: vpbe_venc: convert to devm_* api
  media: davinci: vpbe_osd: convert to devm_* api
  media: davinci: vpbe_display: convert to devm* api
  media: davinci: vpss: convert to devm* api
  media: davinci: vpbe: Replace printk with dev_*

 drivers/media/platform/davinci/vpbe.c         |    6 +-
 drivers/media/platform/davinci/vpbe_display.c |   23 ++----
 drivers/media/platform/davinci/vpbe_osd.c     |   45 +++---------
 drivers/media/platform/davinci/vpbe_venc.c    |   97 +++++--------------------
 drivers/media/platform/davinci/vpss.c         |   62 ++++------------
 5 files changed, 52 insertions(+), 181 deletions(-)

-- 
1.7.9.5

