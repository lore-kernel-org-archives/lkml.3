Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbbAUMlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:41:46 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64351 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbbAUMlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:41:35 -0500
Date: Wed, 21 Jan 2015 16:41:30 +0200
From: Lin Kassem <linsara1@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.chilhabel@googlemail.com,
        gregkh@linuxfoundation.org, gulsah.1004@gmail.com, shack@linux.com,
        thomas@grouk.net, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: fix Missing a blank line after declarations
Message-ID: <20150121144129.GA7195@lin-535U4C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
fix Missing a blank line after declarations

Signed-off-by: Lin Kassem <linsara1@gmail.com>
---
 drivers/staging/rtl8712/drv_types.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index 3d0a98b..9bc300c 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -129,6 +129,7 @@ struct dvobj_priv {
 	struct _adapter *padapter;
 	u32 nr_endpoint;
 	u8   ishighspeed;
+
 	uint(*inirp_init)(struct _adapter *adapter);
 	uint(*inirp_deinit)(struct _adapter *adapter);
 	struct usb_device *pusbdev;
@@ -166,6 +167,7 @@ struct _adapter {
 	 pid_t evtThread;
 	struct task_struct *xmitThread;
 	pid_t recvThread;
+
 	uint(*dvobj_init)(struct _adapter *adapter);
 	void (*dvobj_deinit)(struct _adapter *adapter);
 	struct net_device *pnetdev;
-- 
1.7.9.5

