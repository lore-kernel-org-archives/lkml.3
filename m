Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaCaOxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:53:09 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46516 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCaOxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:53:07 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] DaVinci: VPIF: upgrade with v4l helpers
Date: Mon, 31 Mar 2014 20:22:50 +0530
Message-Id: <1396277573-9513-1-git-send-email-prabhakar.csengg@gmail.com>
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

Lad, Prabhakar (2):
  media: davinci: vpif capture: upgrade the driver with v4l offerings
  media: davinci: vpif display: upgrade the driver with v4l offerings

 drivers/media/platform/davinci/vpif_capture.c |  916 ++++++-------------------
 drivers/media/platform/davinci/vpif_capture.h |   32 +-
 drivers/media/platform/davinci/vpif_display.c |  788 ++++++---------------
 drivers/media/platform/davinci/vpif_display.h |   31 +-
 4 files changed, 446 insertions(+), 1321 deletions(-)

-- 
1.7.9.5

