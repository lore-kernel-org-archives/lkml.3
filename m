Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaFTPEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:04:49 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41548 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaFTPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:46 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 36/41] staging: rtl8188eu: rtl8188e_hal_init.c: Remove forward declarations
Date: Fri, 20 Jun 2014 20:29:42 +0530
Message-Id: <1403276387-11841-37-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 0de4a91..cf94e46 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -728,25 +728,6 @@ enum{
 		LDOE25_SHIFT						= 28 ,
 	};
 
-static bool
-hal_EfusePgPacketWrite2ByteHeader(
-		struct adapter *pAdapter,
-		u8 efuseType,
-		u16				*pAddr,
-		struct pgpkt *pTargetPkt);
-static bool
-hal_EfusePgPacketWrite1ByteHeader(
-		struct adapter *pAdapter,
-		u8 efuseType,
-		u16				*pAddr,
-		struct pgpkt *pTargetPkt);
-static bool
-hal_EfusePgPacketWriteData(
-		struct adapter *pAdapter,
-		u8 efuseType,
-		u16				*pAddr,
-		struct pgpkt *pTargetPkt);
-
 /*
  * Function:	Efuse_PowerSwitch
  *
-- 
1.7.10.4

