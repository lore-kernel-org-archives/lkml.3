Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968207Ab3DSJxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:53:46 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:46204 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968063Ab3DSJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:53:44 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: davinci: vpif trivial cleanup
Date: Fri, 19 Apr 2013 15:23:28 +0530
Message-Id: <1366365210-3778-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

The first patch of the series cleanups the header file inclusion,
and second patch fixes displaying of error when there is actual
failure of request_irq().

Lad, Prabhakar (2):
  media: davinci: vpif: remove unwanted header file inclusion
  media: davinci: vpif_display: move displaying of error to
    approppraite place

 drivers/media/platform/davinci/vpif_capture.c |   19 ++++---------------
 drivers/media/platform/davinci/vpif_capture.h |    5 +----
 drivers/media/platform/davinci/vpif_display.c |   25 ++++---------------------
 drivers/media/platform/davinci/vpif_display.h |    5 +----
 4 files changed, 10 insertions(+), 44 deletions(-)

-- 
1.7.4.1

