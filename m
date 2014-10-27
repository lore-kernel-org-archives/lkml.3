Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaJ0AQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:16:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47076 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaJ0AQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:16:19 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gdonald@gmail.com,
        gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
        Larry.Finger@lwfinger.net
Subject: [PATCH 2/2] staging: rtl8723au: core style issue
Date: Mon, 27 Oct 2014 00:16:08 +0000
Message-Id: <1414368968-9841-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spaces required around %

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 5bc7734..6343d49a 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -2381,7 +2381,7 @@ void rtw_signal_stat_timer_hdl23a(unsigned long data)
 		if (!check_fwstate(&adapter->mlmepriv, _FW_UNDER_SURVEY)) {
 			tmp_s = (avg_signal_strength + (_alpha - 1) *
 				 recvpriv->signal_strength);
-			if (tmp_s %_alpha)
+			if (tmp_s % _alpha)
 				tmp_s = tmp_s / _alpha + 1;
 			else
 				tmp_s = tmp_s / _alpha;
@@ -2390,7 +2390,7 @@ void rtw_signal_stat_timer_hdl23a(unsigned long data)
 
 			tmp_q = (avg_signal_qual + (_alpha - 1) *
 				 recvpriv->signal_qual);
-			if (tmp_q %_alpha)
+			if (tmp_q % _alpha)
 				tmp_q = tmp_q / _alpha + 1;
 			else
 				tmp_q = tmp_q / _alpha;
-- 
1.9.1

