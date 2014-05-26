Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaEZQIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:08:21 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44912 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:08:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 24/24] staging: rtl8188eu: Remove empty file odm_interface.h
Date: Mon, 26 May 2014 21:35:39 +0530
Message-Id: <1401120339-23667-24-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_interface.h |   24 ---------------------
 drivers/staging/rtl8188eu/include/odm_precomp.h   |    1 -
 2 files changed, 25 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/odm_interface.h

diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
deleted file mode 100644
index dc6b1c2..0000000
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-
-#ifndef	__ODM_INTERFACE_H__
-#define __ODM_INTERFACE_H__
-
-#endif	/*  __ODM_INTERFACE_H__ */
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 6e6a656..2eb769b3 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -44,7 +44,6 @@
 #include "Hal8188ERateAdaptive.h"/* for  RA,Power training */
 #include "rtl8188e_hal.h"
 
-#include "odm_interface.h"
 #include "odm_reg.h"
 
 #include "HalHWImg8188E_MAC.h"
-- 
1.7.10.4

