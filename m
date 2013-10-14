Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3JNScl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:32:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23640 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3JNSck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:32:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/g3hBOkbUCqmpBU0kJgRBXENjZDp2wqk=
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: ARM: mvebu: add Sebastian Hesselbarth
Date: Mon, 14 Oct 2013 18:32:21 +0000
Message-Id: <1381775541-24027-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian is a hobbyist who has done a lot of heavy lifting converting
mach-dove to devicetree, and assisting others with patches pertaining to
mvebu.

It is hoped that he will continue this work, and also assist the current
mvebu maintainers with patch wrangling and pull request submissions.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a0cbf3..7a45039 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1009,6 +1009,7 @@ ARM/Marvell Armada 370 and Armada XP SOC support
 M:	Jason Cooper <jason@lakedaemon.net>
 M:	Andrew Lunn <andrew@lunn.ch>
 M:	Gregory Clement <gregory.clement@free-electrons.com>
+M:	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-mvebu/
@@ -1016,6 +1017,7 @@ F:	arch/arm/mach-mvebu/
 ARM/Marvell Dove/Kirkwood/MV78xx0/Orion SOC support
 M:	Jason Cooper <jason@lakedaemon.net>
 M:	Andrew Lunn <andrew@lunn.ch>
+M:	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-dove/
-- 
1.8.3.2

