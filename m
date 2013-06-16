Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3FPWSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:18:20 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:41183 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab3FPWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:18:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Doug Anderson <dianders@chromium.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] MAINTAINERS: Add Samsung pinctrl entries
Date: Sun, 16 Jun 2013 15:17:46 -0700
Message-Id: <1371421068-28743-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371143144-31764-1-git-send-email-dianders@chromium.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's convenient if get_maintainer suggests sending samsung/exynos
pinctrl changes to linux-samsung-soc and to Tomasz and Thomas.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Updated with Thomas and Tomasz; removed Linus since he's already
  there as part of the general pinctrl match.

 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d97b3e..f55e3c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6284,6 +6284,16 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/pinctrl/pinctrl-at91.c
 
+PIN CONTROLLER - SAMSUNG
+M:	Tomasz Figa <t.figa@samsung.com>
+M:	Thomas Abraham <thomas.abraham@linaro.org>
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

