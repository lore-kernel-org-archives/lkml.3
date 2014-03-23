Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaCWGhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:37:39 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61413 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCWGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:37:38 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/2] staging: media: davinci_vpfe: fixes and enhancement
Date: Sun, 23 Mar 2014 12:07:23 +0530
Message-Id: <1395556645-1207-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

The first patch adds v4l2_fh for priority handling and the second
patch makes sure that the buffers are released if start_streaming()
callback fails.

Lad, Prabhakar (2):
  staging: media: davinci: vpfe: use v4l2_fh for priority handling
  staging: media: davinci: vpfe: release buffers in case
    start_streaming call back fails

 .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |    2 --
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   18 ++++++++++++------
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 --
 3 files changed, 12 insertions(+), 10 deletions(-)

-- 
1.7.9.5

