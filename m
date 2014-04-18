Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaDRUYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:24:10 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59759 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaDRUXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:23:55 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad M Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 1/2] staging: rtl8188eu: fix spaces instead of tabs for rtw_p2p.c
Date: Fri, 18 Apr 2014 22:23:06 +0200
Message-Id: <1397852587-8170-2-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397852587-8170-1-git-send-email-bergo.torino@gmail.com>
References: <1397852587-8170-1-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad M Zapalowicz <bergo.torino@gmail.com>

This commit fixes the following checkpatch errors:

rtl8188eu/core/rtw_p2p.c
    - 1508: ERROR: code indent should use tabs where possible
    - 1509: ERROR: code indent should use tabs where possible
    - 1510: ERROR: code indent should use tabs where possible

Signed-off-by: Konrad Zapalowicz <bergo.torino at gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_p2p.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index 9425c49..0a15f8c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -1505,9 +1505,9 @@ static void find_phase_handler(struct adapter *padapter)
 
 	rtw_p2p_set_state(pwdinfo, P2P_STATE_FIND_PHASE_SEARCH);
 
-        spin_lock_bh(&pmlmepriv->lock);
-        rtw_sitesurvey_cmd(padapter, &ssid, 1, NULL, 0);
-        spin_unlock_bh(&pmlmepriv->lock);
+	spin_lock_bh(&pmlmepriv->lock);
+	rtw_sitesurvey_cmd(padapter, &ssid, 1, NULL, 0);
+	spin_unlock_bh(&pmlmepriv->lock);
 }
 
 void p2p_concurrent_handler(struct adapter *padapter);
-- 
1.8.1.2

