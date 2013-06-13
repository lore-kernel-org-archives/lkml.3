Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3FMRGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:06:14 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:45008 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3FMRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:06:11 -0400
From: Doug Anderson <dianders@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-samsung-soc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Thu, 13 Jun 2013 10:05:44 -0700
Message-Id: <1371143144-31764-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's convenient if get_maintainer suggests sending samsung/exynos
pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry for
that.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d97b3e..d026e38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6284,6 +6284,16 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/pinctrl/pinctrl-at91.c
 
+PIN CONTROLLER - SAMSUNG
+M:	Linus Walleij <linus.walleij@linaro.org>
+M:	Kukjin Kim <kgene.kim@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/pinctrl/pinctrl-exynos.*
+F:	drivers/pinctrl/pinctrl-s3c*
+F:	drivers/pinctrl/pinctrl-samsung.*
+
 PIN CONTROLLER - ST SPEAR
 M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
-- 
1.8.3

