Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3EPM6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:58:39 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:53261 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3EPM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:58:38 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/7] media: davinci: vpif trivial cleanup
Date: Thu, 16 May 2013 18:28:15 +0530
Message-Id: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series cleans the VPIF driver, uses devm_* api wherever
required and uses module_platform_driver() to simplify the code.

This patch series applies on 3.10.rc1 and is tested on OMAP-L138.

Lad, Prabhakar (7):
  media: davinci: vpif: remove unwanted header includes
  media: davinci: vpif: Convert to devm_* api
  media: davinci: vpif: remove unnecessary braces around defines
  media: davinci: vpif_capture: remove unwanted header inclusion and
    sort them alphabetically
  media: davinci: vpif_capture: Convert to devm_* api
  media: davinci: vpif_display: remove unwanted header inclusion and
    sort them alphabetically
  media: davinci: vpif_display: Convert to devm_* api

 drivers/media/platform/davinci/vpif.c         |   42 ++---------
 drivers/media/platform/davinci/vpif_capture.c |   96 +++++--------------------
 drivers/media/platform/davinci/vpif_capture.h |    6 +-
 drivers/media/platform/davinci/vpif_display.c |   85 ++++------------------
 drivers/media/platform/davinci/vpif_display.h |    6 +-
 5 files changed, 46 insertions(+), 189 deletions(-)

-- 
1.7.4.1

