Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaJSOQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 10:16:40 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34167 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaJSOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 10:16:35 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, joe@perches.com, mchehab@osg.samsung.com,
        crope@iki.fi
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 3/4] MAINTAINERS: Add myself as maintainer of Allwinner Security System
Date: Sun, 19 Oct 2014 16:16:21 +0200
Message-Id: <1413728182-13569-4-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 33c0d43..8ee4ac0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10425,6 +10425,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+ALLWINNER SECURITY SYSTEM
+M:	Corentin Labbe <clabbe.montjoie@gmail.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/sunxi-ss/
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.0.4

