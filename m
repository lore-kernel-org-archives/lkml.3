Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3FDXJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:09:03 -0400
Received: from 1wt.eu ([62.212.114.60]:35527 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab3FDWmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:38 -0400
Message-Id: <20130604172134.124569403@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Francois Romieu <romieu@fr.zoreil.com>, Hayes <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>, Thomas Bork <tom@eisfair.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 092/184] r8169: incorrect identifier for a 8168dp
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Merge error.

See CFG_METHOD_8 (0x3c800000 + 0x00300000) since version 8.002.00
of Realtek's driver.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 17c99297212a2d1b1779a08caf4b0d83a85545df)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/r8169.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 2d89062..7ddbb8e 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1307,7 +1307,7 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp,
 		{ 0x7c800000, 0x28000000,	RTL_GIGA_MAC_VER_26 },
 
 		/* 8168C family. */
-		{ 0x7cf00000, 0x3ca00000,	RTL_GIGA_MAC_VER_24 },
+		{ 0x7cf00000, 0x3cb00000,	RTL_GIGA_MAC_VER_24 },
 		{ 0x7cf00000, 0x3c900000,	RTL_GIGA_MAC_VER_23 },
 		{ 0x7cf00000, 0x3c800000,	RTL_GIGA_MAC_VER_18 },
 		{ 0x7c800000, 0x3c800000,	RTL_GIGA_MAC_VER_24 },
-- 
1.7.12.2.21.g234cd45.dirty



