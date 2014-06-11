Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaFKRWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:22:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62585 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaFKRWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:22:34 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/22] staging: rtl8188eu: rtw_io.h: Remove unused function declarations
Date: Wed, 11 Jun 2014 22:51:24 +0530
Message-Id: <1402507301-3722-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_io.h |   43 ----------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 4c8a8c1..5c76815 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -122,51 +122,8 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_write_port((adapter), (addr), (cnt), (mem))
 #define rtw_write_port_cancel(adapter) _rtw_write_port_cancel((adapter))
 
-void rtw_write_scsi(struct adapter *adapter, u32 cnt, u8 *pmem);
-
-/* ioreq */
-void ioreq_read8(struct adapter *adapter, u32 addr, u8 *pval);
-void ioreq_read16(struct adapter *adapter, u32 addr, u16 *pval);
-void ioreq_read32(struct adapter *adapter, u32 addr, u32 *pval);
-void ioreq_write8(struct adapter *adapter, u32 addr, u8 val);
-void ioreq_write16(struct adapter *adapter, u32 addr, u16 val);
-void ioreq_write32(struct adapter *adapter, u32 addr, u32 val);
-
-uint async_read8(struct adapter *adapter, u32 addr, u8 *pbuff,
-		 void (*_async_io_callback)(struct adapter *padater,
-					    struct io_req *pio_req,
-					    u8 *cnxt), u8 *cnxt);
-uint async_read16(struct adapter *adapter, u32 addr,  u8 *pbuff,
-		  void (*_async_io_callback)(struct adapter *padater,
-					     struct io_req *pio_req,
-					     u8 *cnxt), u8 *cnxt);
-uint async_read32(struct adapter *adapter, u32 addr,  u8 *pbuff,
-		  void (*_async_io_callback)(struct adapter *padater,
-					     struct io_req *pio_req,
-					     u8 *cnxt), u8 *cnxt);
-
-void async_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-void async_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-
-void async_write8(struct adapter *adapter, u32 addr, u8 val,
-		  void (*_async_io_callback)(struct adapter *padater,
-					     struct io_req *pio_req,
-					     u8 *cnxt), u8 *cnxt);
-void async_write16(struct adapter *adapter, u32 addr, u16 val,
-		   void (*_async_io_callback)(struct adapter *padater,
-					      struct io_req *pio_req,
-					      u8 *cnxt), u8 *cnxt);
-void async_write32(struct adapter *adapter, u32 addr, u32 val,
-		   void (*_async_io_callback)(struct adapter *padater,
-					      struct io_req *pio_req,
-					      u8 *cnxt), u8 *cnxt);
-
-void async_write_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-void async_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
 
-void dev_power_down(struct adapter *Adapter, u8 bpwrup);
-
 #endif	/* _RTL8711_IO_H_ */
-- 
1.7.10.4

