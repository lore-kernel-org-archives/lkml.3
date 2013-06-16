Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3FPWSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:18:18 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58518 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3FPWSO (ORCPT
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
Subject: [PATCH v2 2/2] MAINTAINERS: Add exynos filename match to ARM/S5P EXYNOS ARM ARCHITECTURES
Date: Sun, 16 Jun 2013 15:17:47 -0700
Message-Id: <1371421068-28743-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371421068-28743-1-git-send-email-dianders@chromium.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
 <1371421068-28743-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help direct patches related to exynos to the
linux-samsung-soc mailing list for discussion.

Suggested by Joe Perches.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- New for this version.

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f55e3c7..2e95fd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1140,6 +1140,7 @@ L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5p*/
 F:	arch/arm/mach-exynos*/
+N:	exynos
 
 ARM/SAMSUNG MOBILE MACHINE SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-- 
1.8.3

