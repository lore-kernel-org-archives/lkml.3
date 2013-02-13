Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab3BMDBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:01:21 -0500
Received: from mout.gmx.net ([212.227.17.21]:51607 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759610Ab3BMDBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:01:14 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18kx/Iq7GgkS5/Qex4w1L90zRzVsFy4UHZof/ry2a
	//vM6XygAg41NT
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Andrew Miller <amiller@amilx.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] staging/rtl8187se: Remove unused functions PlatformIORead2Byte / PlatformIORead4Byte
Date: Wed, 13 Feb 2013 04:05:24 +0100
Message-Id: <1360724726-2997-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724302-2794-4-git-send-email-peterhuewe@gmx.de>
References: <1360724302-2794-4-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions PlatformIORead2Byte and PlatformIORead4Byte are
unused and thus can be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 1dfa78e..005fb0b 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -175,26 +175,6 @@ void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 	}
 }
 
-u16 PlatformIORead2Byte(struct net_device *dev, u32 offset)
-{
-	u16	data = 0;
-
-	data = read_nic_word(dev, offset);
-
-
-	return data;
-}
-
-u32 PlatformIORead4Byte(struct net_device *dev, u32 offset)
-{
-	u32	data = 0;
-
-	data = read_nic_dword(dev, offset);
-
-
-	return data;
-}
-
 void SetOutputEnableOfRfPins(struct net_device *dev)
 {
 	write_nic_word(dev, RFPinsEnable, 0x1bff);
-- 
1.7.8.6

