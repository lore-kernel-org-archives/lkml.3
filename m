Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaEGD6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:58:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63929 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaEGD6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:58:34 -0400
X-Google-Original-Message-ID: <1399435056-32386-3-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/13] staging: rtl8188eu: Remove unused member variables of struct recv_priv
Date: Wed,  7 May 2014 09:27:25 +0530
Message-Id: <5369af66.0382440a.71b7.1dd2@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 5b3bf29..d52cfe8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -189,10 +189,6 @@ struct recv_priv {
 	u64	rx_drop;
 	u64	last_rx_bytes;
 
-	uint  rx_icv_err;
-	uint  rx_largepacket_crcerr;
-	uint  rx_smallpacket_crcerr;
-	uint  rx_middlepacket_crcerr;
 	uint	ff_hwaddr;
 	u8	rx_pending_cnt;
 
@@ -212,9 +208,7 @@ struct recv_priv {
 	u8 signal_strength;
 	u8 signal_qual;
 	u8 noise;
-	int RxSNRdB[2];
 	s8 RxRssi[2];
-	int FalseAlmCnt_all;
 
 	struct timer_list signal_stat_timer;
 	u32 signal_stat_sampling_interval;
-- 
1.7.10.4

