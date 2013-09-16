Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3IPNoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:44:05 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59891 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3IPNoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:01 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/24] Staging: winbond: mto: removed function declaration
Date: Mon, 16 Sep 2013 15:43:21 +0200
Message-Id: <1379339024-12157-2-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following function declarations have been removed because they aren't implemented.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/mto.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 560c0ab..0d0f9fb 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -46,10 +46,7 @@ static int retryrate_rec[MTO_MAX_DATA_RATE_LEVELS];
 static u8 boSparseTxTraffic;
 
 void MTO_Init(struct wbsoft_priv *adapter);
-void TxRateReductionCtrl(struct wbsoft_priv *adapter);
 void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
-void MTO_TxFailed(struct wbsoft_priv *adapter);
-void hal_get_dto_para(struct wbsoft_priv *adapter, char *buffer);
 
 /*
  * ===========================================================================
-- 
1.8.1.2

