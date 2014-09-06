Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaIFP1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:27:45 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:61349 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaIFP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:27:40 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/5] media: davinci: vpif fixes
Date: Sat,  6 Sep 2014 16:26:46 +0100
Message-Id: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch series fixes several small issues in VPIF driver.

Lad, Prabhakar (5):
  media: davinci: vpif_display: drop setting of vb2 buffer state to
    ACTIVE
  media: davinci: vpif_capture: drop setting of vb2 buffer state to
    ACTIVE
  media: videobuf2-core.h: add a helper to get status of
    start_streaming()
  media: davinci: vpif_display: fix the check on suspend/resume
    callbacks
  media: davinci: vpif_capture: fix the check on suspend/resume
    callbacks

 drivers/media/platform/davinci/vpif_capture.c | 7 ++-----
 drivers/media/platform/davinci/vpif_display.c | 8 ++------
 include/media/videobuf2-core.h                | 9 +++++++++
 3 files changed, 13 insertions(+), 11 deletions(-)

-- 
1.9.1

