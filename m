Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaABXXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:23:35 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:39452 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaABXXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:23:34 -0500
Date: Fri, 3 Jan 2014 00:22:59 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging: rtl8188eu: Fixed coding style issues
Message-ID: <20140102232259.GA4112@archlinux>
References: <20140102204640.GA1149@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102204640.GA1149@archlinux>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indentation coding style issues on rtw_io.c

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/core/rtw_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 10c9c65..f1b8dfe 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -205,9 +205,9 @@ void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 
 	_func_enter_;
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
-	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
-		      ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
-		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
+		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
+			 ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
+			 adapter->bDriverStopped, adapter->bSurpriseRemoved));
 	     return;
 	}
 	_read_mem = pintfhdl->io_ops._read_mem;
@@ -239,9 +239,9 @@ void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 	_func_enter_;
 
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
-	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
-		      ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
-		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
+		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
+			 ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
+			 adapter->bDriverStopped, adapter->bSurpriseRemoved));
 	     return;
 	}
 
-- 
1.8.5.2

