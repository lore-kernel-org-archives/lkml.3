Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905Ab3DOFdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:33:05 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:65066 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab3DOFdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:33:03 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        David Miller <davem@davemloft.net>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH] MAINTAINERS: change entry for davinci media driver
Date: Mon, 15 Apr 2013 11:02:44 +0530
Message-Id: <1366003964-4675-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

As of now TI has no maintainer/supporter for davinci media
drivers, Until it has any I'll be maintaining it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 MAINTAINERS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bbe872e..4cf48e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7244,14 +7244,13 @@ F:	arch/arm/mach-davinci
 F:	drivers/i2c/busses/i2c-davinci.c
 
 TI DAVINCI SERIES MEDIA DRIVER
-M:	Manjunath Hadli <manjunath.hadli@ti.com>
-M:	Prabhakar Lad <prabhakar.lad@ti.com>
+M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers)
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
-S:	Supported
+S:	Maintained
 F:	drivers/media/platform/davinci/
 F:	include/media/davinci/
 
-- 
1.7.4.1

