Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaFFQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37090 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaFFQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:24 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/13] staging: rtl8188eu: Remove unused function declaration and macro
Date: Fri,  6 Jun 2014 21:45:16 +0530
Message-Id: <1402071320-14400-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_io.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 958fc52..e30b84b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -239,7 +239,6 @@ struct io_priv {
 u8 _rtw_read8(struct adapter *adapter, u32 addr);
 u16 _rtw_read16(struct adapter *adapter, u32 addr);
 u32 _rtw_read32(struct adapter *adapter, u32 addr);
-void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void _rtw_read_port_cancel(struct adapter *adapter);
 
@@ -260,8 +259,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
 #define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
 #define rtw_read32(adapter, addr) _rtw_read32((adapter), (addr))
-#define rtw_read_mem(adapter, addr, cnt, mem)				\
-	_rtw_read_mem((adapter), (addr), (cnt), (mem))
 #define rtw_read_port(adapter, addr, cnt, mem)				\
 	_rtw_read_port((adapter), (addr), (cnt), (mem))
 #define rtw_read_port_cancel(adapter) _rtw_read_port_cancel((adapter))
-- 
1.7.10.4

