Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaABREc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:04:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52501 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaABREa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:04:30 -0500
Date: Thu, 2 Jan 2014 18:03:56 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8188eu: Fixed coding style issues
Message-ID: <20140102170356.GA29980@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indentation coding style issues on rtw_io.c

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/core/rtw_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 10c9c65..69b408e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -205,7 +205,7 @@ void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 
 	_func_enter_;
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
-	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
+		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
 		      ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
 		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
 	     return;
@@ -239,7 +239,7 @@ void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 	_func_enter_;
 
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
-	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
+		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
 		      ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
 		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
 	     return;
-- 
1.8.5.2

