Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3JSOmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:42:19 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:36450 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab3JSOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org,>);
	Sat, 19 Oct 2013 10:39:22 -0400
X-RRZE-Submit-IP: 212.255.122.85
From: Dominik Paulus <dominik.paulus@fau.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, tobias.polzer@fau.de,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: [PATCHv4 08/16] staging: usbip: Improve debug output
Date: Sat, 19 Oct 2013 16:39:11 +0200
Message-Id: <1382193559-12549-9-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For IPv6, IP:Port is unreadable.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/src/usbipd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index ae572c6..6550460 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -519,7 +519,7 @@ static int do_accept(int listenfd)
 		return -1;
 	}
 #endif
-	info("connection from %s:%s", host, port);
+	info("connection from %s, port %s", host, port);
 
 	return connfd;
 }
-- 
1.8.4.1

