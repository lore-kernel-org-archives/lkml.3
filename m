Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbaJINy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:54:57 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:55847 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaJINyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:54:18 -0400
From: Jia He <hejianet@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jia He <hejianet@gmail.com>
Subject: [PATCH 2/2] staging: rtl8188eu: Fix coding style not using tab problem
Date: Thu,  9 Oct 2014 21:53:53 +0800
Message-Id: <1412862833-19015-3-git-send-email-hejianet@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412862833-19015-1-git-send-email-hejianet@gmail.com>
References: <1412845387-17668-1-git-send-email-hejianet@gmail.com>
 <1412862833-19015-1-git-send-email-hejianet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes "ERROR: code indent should use tabs where possible"

Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/hal/rf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/rf.c b/drivers/staging/rtl8188eu/hal/rf.c
index eea4c8a..8e7a0b1 100644
--- a/drivers/staging/rtl8188eu/hal/rf.c
+++ b/drivers/staging/rtl8188eu/hal/rf.c
@@ -102,7 +102,7 @@ void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt, u8 *powerlevel)
 		}
 	}
 	rtl88eu_dm_txpower_track_adjust(&hal_data->odmpriv, 1, &direction,
-				        &pwrtrac_value);
+					&pwrtrac_value);
 
 	if (direction == 1) {
 		/*  Increase TX power */
-- 
1.9.3

