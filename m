Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaEZQHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:05 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37727 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/24] staging: rtl8188eu: remove unused header inclusion from rtw_mp.c
Date: Mon, 26 May 2014 21:35:26 +0530
Message-Id: <1401120339-23667-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mp.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 705f666..17427a6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -21,7 +21,6 @@
 
 #include <drv_types.h>
 
-#include "odm_precomp.h"
 #include "rtl8188e_hal.h"
 #include <linux/vmalloc.h>
 
-- 
1.7.10.4

