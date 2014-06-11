Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbaFKRYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:24:19 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45818 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbaFKRYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:15 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/22] staging: rtl8188eu: usb_ops_linux.h: Remove unused function declarations
Date: Wed, 11 Jun 2014 22:51:38 +0530
Message-Id: <1402507301-3722-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_ops_linux.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_ops_linux.h b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
index e722c45..0a6e5d0 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops_linux.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
@@ -44,9 +44,6 @@
 
 unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr);
 
-void usb_read_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem);
-void usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem);
-
 void usb_read_port_cancel(struct adapter *padapter);
 
 u32 usb_write_port(struct adapter *padapter, u32 addr, u32 cnt, u8 *wmem);
-- 
1.7.10.4

