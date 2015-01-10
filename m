Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbbAJLCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 06:02:46 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47653 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752144AbbAJLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 06:02:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-wireless@vger.kernel.org,
        "Michael Renzmann" <mrenzmann@madwifi-project.org>
Subject: [PATCH 1/1] MAINTAINERS: remove ath5k mailing list
Date: Sat, 10 Jan 2015 12:02:40 +0100
Message-Id: <1420887760-9979-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list is in the process of closing.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Cc: "Michael Renzmann" <mrenzmann@madwifi-project.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0519e79197ad..5ce30f9810b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1596,7 +1596,6 @@ M:	Jiri Slaby <jirislaby@gmail.com>
 M:	Nick Kossifidis <mickflemm@gmail.com>
 M:	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
 L:	linux-wireless@vger.kernel.org
-L:	ath5k-devel@lists.ath5k.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath5k
 S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
-- 
2.2.1

