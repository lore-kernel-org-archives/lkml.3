Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaBGMSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:18:17 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54989 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaBGMSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:18:12 -0500
Date: Fri, 7 Feb 2014 17:48:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 01/26] drivers: isdn: Rectify typing error in xdi_msg.h
Message-ID: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rectify typing error while including the guard for the header
file xdi_msg.h so that proper guard is wrapped around the file
to prevent it from being included more than once.

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/xdi_msg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/eicon/xdi_msg.h b/drivers/isdn/hardware/eicon/xdi_msg.h
index 58368f7..2498c34 100644
--- a/drivers/isdn/hardware/eicon/xdi_msg.h
+++ b/drivers/isdn/hardware/eicon/xdi_msg.h
@@ -1,6 +1,6 @@
 /* $Id: xdi_msg.h,v 1.1.2.2 2001/02/16 08:40:36 armin Exp $ */
 
-#ifndef __DIVA_XDI_UM_CFG_MESSSGE_H__
+#ifndef __DIVA_XDI_UM_CFG_MESSAGE_H__
 #define __DIVA_XDI_UM_CFG_MESSAGE_H__
 
 /*
-- 
1.7.9.5

