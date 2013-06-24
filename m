Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FXPr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:47:59 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43700 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3FXPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:47:57 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] tvp514x/tvp7002 remove manual setting of subdev names
Date: Mon, 24 Jun 2013 21:17:24 +0530
Message-Id: <1372088846-26263-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series removes manual setting of subdev names, as
ideally the subdev names must be unique and this would not be
the case if there are two devices.

Lad, Prabhakar (2):
  media: i2c: tvp7002: remove manual setting of subdev name
  media: i2c: tvp514x: remove manual setting of subdev name

 drivers/media/i2c/tvp514x.c |    1 -
 drivers/media/i2c/tvp7002.c |    1 -
 2 files changed, 2 deletions(-)

-- 
1.7.9.5

