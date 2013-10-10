Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3JJBCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:02:18 -0400
Received: from host171.canaca.com ([67.55.55.225]:38450 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3JJBCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:02:15 -0400
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Elias Vanderstuyft <elias.vds@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Subject: [PATCH 3/3] HID:Kconfig: Correct MOMO description in wrong place (handled by LG4FF).
Date: Wed,  9 Oct 2013 18:04:47 -0600
Message-Id: <1381363487-2167-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381363487-2167-1-git-send-email-simon@mungewell.org>
References: <1381363487-2167-1-git-send-email-simon@mungewell.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 46fd27f..aee7182 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -362,7 +362,6 @@ config LOGITECH_FF
 	  - Logitech WingMan Force 3D
 	  - Logitech Formula Force EX
 	  - Logitech WingMan Formula Force GP
-	  - Logitech MOMO Force wheel
 
 	  and if you want to enable force feedback for them.
 	  Note: if you say N here, this device will still be supported, but without
-- 
1.8.1.2

