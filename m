Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaFFRod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:44:33 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62227 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaFFRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:44:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/13] staging: rtl8188eu: rtw_io.h: Remove unused members from struct _io_ops
Date: Fri,  6 Jun 2014 23:13:18 +0530
Message-Id: <1402076598-29637-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_io.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 9c6384b..bc36129 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -55,12 +55,10 @@ struct _io_ops {
 	int (*_write8_async)(struct intf_hdl *pintfhdl, u32 addr, u8 val);
 	int (*_write16_async)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
 	int (*_write32_async)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
-	u32 (*_read_interrupt)(struct intf_hdl *pintfhdl, u32 addr);
 	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
 			  u8 *pmem);
 	u32 (*_write_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
 			   u8 *pmem);
-	u32 (*_write_scsi)(struct intf_hdl *pintfhdl, u32 cnt, u8 *pmem);
 	void (*_read_port_cancel)(struct intf_hdl *pintfhdl);
 	void (*_write_port_cancel)(struct intf_hdl *pintfhdl);
 };
--
1.7.10.4

