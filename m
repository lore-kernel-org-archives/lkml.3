Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaBUMHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:07:38 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40582 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbaBUMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:07:37 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/3] media: omap3isp: trivial cleanup
Date: Fri, 21 Feb 2014 17:37:20 +0530
Message-Id: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series include fixing some typos and
removal of unwanted comments. 

Lad, Prabhakar (3):
  media: omap3isp: fix typos
  media: omap3isp: ispccdc: remove unwanted comments
  media: omap3isp: rename the variable names in description

 drivers/media/platform/omap3isp/isp.c        |    2 +-
 drivers/media/platform/omap3isp/isp.h        |   12 ++++++------
 drivers/media/platform/omap3isp/ispccdc.c    |   10 +++++-----
 drivers/media/platform/omap3isp/ispccdc.h    |    6 ------
 drivers/media/platform/omap3isp/ispccp2.c    |    6 +++---
 drivers/media/platform/omap3isp/isphist.c    |    4 ++--
 drivers/media/platform/omap3isp/isppreview.c |   13 +++++++------
 drivers/media/platform/omap3isp/ispqueue.c   |    2 +-
 drivers/media/platform/omap3isp/ispresizer.c |    6 +++---
 drivers/media/platform/omap3isp/ispresizer.h |    4 ++--
 drivers/media/platform/omap3isp/ispstat.c    |    4 ++--
 drivers/media/platform/omap3isp/ispvideo.c   |    4 ++--
 12 files changed, 34 insertions(+), 39 deletions(-)

-- 
1.7.9.5

