Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3EPHLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:11:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34534 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3EPHLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:11:09 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] video: da8xx-fb trival cleanup
Date: Thu, 16 May 2013 12:40:55 +0530
Message-Id: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series cleans the header inclusion and uses devm_* api
in the driver.

This patch series applies on 3.10-rc1 and is only boot
tested enabling FB driver.

Lad, Prabhakar (2):
  video: da8xx-fb: remove unwanted header inclusion and sort the
    alphabetically
  video:da8xx-fb: Convert to devm_* api

 drivers/video/da8xx-fb.c |   62 ++++++++++++---------------------------------
 1 files changed, 17 insertions(+), 45 deletions(-)

-- 
1.7.4.1

