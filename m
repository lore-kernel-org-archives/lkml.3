Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaDDFRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:17:47 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36470 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDDFRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:17:44 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 0/2] DaVinci: VPIF: upgrade with v4l helpers
Date: Fri,  4 Apr 2014 10:47:34 +0530
Message-Id: <1396588656-6660-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Hi All,

This patch series upgrades the vpif capture & display
driver with the all the helpers provided by v4l, this makes
the driver much simpler and cleaner. This also includes few
checkpatch issues.

Sending them as single patch one for capture and another for
display, splitting them would have caused a huge number small
patches.

Changes for v2:
a> Added a copyright.
b> Dropped buf_init() callback from vb2_ops.
c> Fixed enabling & disabling of interrupts in case of HD formats.


Lad, Prabhakar (2):
  media: davinci: vpif capture: upgrade the driver with v4l offerings
  media: davinci: vpif display: upgrade the driver with v4l offerings

 drivers/media/platform/davinci/vpif_capture.c |  931 +++++++------------------
 drivers/media/platform/davinci/vpif_capture.h |   32 +-
 drivers/media/platform/davinci/vpif_display.c |  800 ++++++---------------
 drivers/media/platform/davinci/vpif_display.h |   31 +-
 4 files changed, 455 insertions(+), 1339 deletions(-)

-- 
1.7.9.5

