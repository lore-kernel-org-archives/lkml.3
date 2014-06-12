Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbaFLRD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:03:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34439 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbaFLRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:03:24 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, mporter@linaro.org, patches@linaro.org,
        bjorn@kryo.se, ashwin.chaugule@linaro.org, gregkh@linuxfoundation.org,
        s-anna@ti.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        pawel.moll@arm.com, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, arnd@arndb.de, joshc@codeaurora.org,
        linus.walleij@linaro.org, galak@codeaurora.org, ks.giri@samsung.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv7 5/5] MAINTAINERS: Add maintainer entry for Mailbox API
Date: Thu, 12 Jun 2014 22:32:54 +0530
Message-Id: <1402592574-7355-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as the maintainer of mailbox api

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b4a66b9..7f6651b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5633,6 +5633,14 @@ S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_macvlan.h
 
+MAILBOX API
+M:	Jassi Brar <jassisinghbrar@gmail.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/mailbox/
+F:	include/linux/mailbox_client.h
+F:	include/linux/mailbox_controller.h
+
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 M:	Michael Kerrisk <mtk.manpages@gmail.com>
 W:	http://www.kernel.org/doc/man-pages
-- 
1.8.1.2

