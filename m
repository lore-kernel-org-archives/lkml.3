Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaCKKbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:31:33 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:43645 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaCKKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH trivial 08/16] packet: doc: Spelling s/than/that/
Date: Tue, 11 Mar 2014 11:23:42 +0100
Message-Id: <1394533430-4746-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 Documentation/networking/packet_mmap.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/packet_mmap.txt b/Documentation/networking/packet_mmap.txt
index 1404674c0a02..6fea79efb4cb 100644
--- a/Documentation/networking/packet_mmap.txt
+++ b/Documentation/networking/packet_mmap.txt
@@ -453,7 +453,7 @@ TP_STATUS_COPY        : This flag indicates that the frame (and associated
                         enabled previously with setsockopt() and 
                         the PACKET_COPY_THRESH option. 
 
-                        The number of frames than can be buffered to 
+                        The number of frames that can be buffered to
                         be read with recvfrom is limited like a normal socket.
                         See the SO_RCVBUF option in the socket (7) man page.
 
-- 
1.7.9.5

