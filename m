Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3EZMBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 08:01:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35486 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3EZMBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 08:01:14 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 0/9] media: davinci: vpif trivial cleanup
Date: Sun, 26 May 2013 17:30:03 +0530
Message-Id: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series cleans the VPIF driver, uses devm_* api wherever
required and uses module_platform_driver() to simplify the code.

This patch series applies on http://git.linuxtv.org/hverkuil/media_tree.git/
shortlog/refs/heads/for-v3.11 and is tested on OMAP-L138.

Changes for v2:
1: Rebased on v3.11 branch of Hans.
2: Dropped the patches which removed headers as mentioned by Laurent.

Changes for v3:
1: Splitted the patches logically as mentioned by Laurent.
2: Fixed review comments pointed by Laurent.
3: Included Ack's.


Lad, Prabhakar (9):
  media: davinci: vpif: remove unwanted header mach/hardware.h and sort
    the includes alphabetically
  media: davinci: vpif: Convert to devm_* api
  media: davinci: vpif: remove unnecessary braces around defines
  media: davinci: vpif_capture: move the freeing of irq and global
    variables to remove()
  media: davinci: vpif_capture: use module_platform_driver()
  media: davinci: vpif_capture: Convert to devm_* api
  media: davinci: vpif_display: move the freeing of irq and global
    variables to remove()
  media: davinci: vpif_display: use module_platform_driver()
  media: davinci: vpif_display: Convert to devm_* api

 drivers/media/platform/davinci/vpif.c         |   45 ++++-----------
 drivers/media/platform/davinci/vpif_capture.c |   75 +++++--------------------
 drivers/media/platform/davinci/vpif_display.c |   63 ++++----------------
 3 files changed, 40 insertions(+), 143 deletions(-)

