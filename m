Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaCVLDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:03:37 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50917 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCVLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:03:33 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH RESEND for v3.15 0/3] Davinci: media: fix releasing of active buffers
Date: Sat, 22 Mar 2014 16:33:06 +0530
Message-Id: <1395486189-16713-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Resending the patch series as it missed DLOS ML.
No-changes from previous version.

This patch series fixes the releasing of active buffers in davinci
drivers which are migrated to vb2.

Hi Hans,
This patches are just fixes to v3.15, more patches coming soon
for vpif using v4l helpers for v3.16.


Lad, Prabhakar (3):
  media: davinci: vpif_capture: fix releasing of active buffers
  media: davinci: vpif_display: fix releasing of active buffers
  media: davinci: vpbe_display: fix releasing of active buffers

 drivers/media/platform/davinci/vpbe_display.c |   16 ++++++++++-
 drivers/media/platform/davinci/vpif_capture.c |   34 ++++++++++++++++--------
 drivers/media/platform/davinci/vpif_display.c |   35 ++++++++++++++++---------
 3 files changed, 61 insertions(+), 24 deletions(-)

-- 
1.7.9.5

