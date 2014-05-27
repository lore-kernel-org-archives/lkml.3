Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaE0Ph2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:37:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54646 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaE0PhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/15] staging: rtl8188eu:Remove unused variable struct adapter *pbuddy_padapter
Date: Tue, 27 May 2014 21:05:50 +0530
Message-Id: <1401204955-4093-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index c1195a0..6fb8caa 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1661,5 +1661,3 @@ void beacon_timing_control(struct adapter *padapter)
 {
 	rtw_hal_bcn_related_reg_setting(padapter);
 }
-
-static struct adapter *pbuddy_padapter;
-- 
1.7.10.4

