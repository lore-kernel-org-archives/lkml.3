Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbbAVGji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:39:38 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49969 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbAVGjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:39:31 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: remove unused function
Date: Thu, 22 Jan 2015 12:09:16 +0530
Message-Id: <1421908756-22544-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mp_query_drv_var() was only being used by
oid_rt_pro_query_dr_variable_hdl() but after commit
<f4f5a59ff2e746885be3c1c06c1d0e8861a10ce8> mp_query_drv_var() became
unused. so it is safe to remove it.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
index 49fa1d1..0b54612 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
@@ -704,13 +704,6 @@ uint oid_rt_get_thermal_meter_hdl(struct oid_par_priv *poid_par_priv)
 	return RNDIS_STATUS_SUCCESS;
 }
 
-/*--------------------------------------------------------------------------*/
-static u32 mp_query_drv_var(struct _adapter *padapter, u8 offset, u32 var)
-{
-	return var;
-}
-
-/*------------------------------------------------------------------------*/
 uint oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
-- 
1.8.1.2

