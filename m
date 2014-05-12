Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaELI6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:58:47 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58625 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaELI6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:58:46 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 0/2] DaVinci: vpif: upgrade with v4l helpers
Date: Mon, 12 May 2014 14:28:28 +0530
Message-Id: <1399885110-9899-1-git-send-email-prabhakar.csengg@gmail.com>
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

Changes for v3:
a> Fixed review comments pointed by Hans.

Changes for v4:
a> Rebased the patches on top of 
[media] vb2: stop_streaming should return void.

Lad, Prabhakar (2):
  media: davinci: vpif capture: upgrade the driver with v4l offerings
  media: davinci: vpif display: upgrade the driver with v4l offerings

 drivers/media/platform/davinci/vpif_capture.c | 1471 ++++++++-----------------
 drivers/media/platform/davinci/vpif_capture.h |   43 +-
 drivers/media/platform/davinci/vpif_display.c | 1257 +++++++--------------
 drivers/media/platform/davinci/vpif_display.h |   46 +-
 4 files changed, 842 insertions(+), 1975 deletions(-)

-- 
1.7.9.5

