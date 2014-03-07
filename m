Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaCGKK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:10:27 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:59048 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaCGKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:10:23 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] MAINTAINERS: add xtensa irqchips to xtensa port entry
Date: Fri,  7 Mar 2014 14:09:13 +0400
Message-Id: <1394186953-15841-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that irqchip drivers for xtensa live outside arch/xtensa we'd like
to add them to our maintenance list.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6d0e93..a30b047 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8690,6 +8690,7 @@ M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	arch/xtensa/
+F:	drivers/irqchip/irq-xtensa-*
 
 THANKO'S RAREMONO AM/FM/SW RADIO RECEIVER USB DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
-- 
1.8.1.4

