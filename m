Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaJBHUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:20:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39226 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180AbaJBHUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:20:38 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org, paul@pwsan.com
Cc: davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        m.chehab@samsung.com, crope@iki.fi, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: remove Rajendra Nayak, invalid e-mail
Date: Thu,  2 Oct 2014 09:20:27 +0200
Message-Id: <1412234427-17422-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes Rajendra Nayak from the MAINTAINERS file
as his e-mail address is now rejected by the TI mail server.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 37054306dc9f..db449ee19ca8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6496,7 +6496,6 @@ F:	arch/arm/*omap*/*pm*
 F:	drivers/cpufreq/omap-cpufreq.c
 
 OMAP POWERDOMAIN SOC ADAPTATION LAYER SUPPORT
-M:	Rajendra Nayak <rnayak@ti.com>
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-- 
1.9.1

