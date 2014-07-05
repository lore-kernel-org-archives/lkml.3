Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200AbaGEUbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:31:09 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38723 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaGEUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:31:02 -0400
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: nvec: remove unnecessary 'else' after 'return' statement
Date: Sat,  5 Jul 2014 22:30:55 +0200
Message-Id: <55d9b3cb9cf1c54d1fc87dd1d6a582f6067cc295.1404586529.git.pawel.lebioda89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1404586529.git.pawel.lebioda89@gmail.com>
References: <cover.1404586529.git.pawel.lebioda89@gmail.com>
In-Reply-To: <cover.1404586529.git.pawel.lebioda89@gmail.com>
References: <cover.1404586529.git.pawel.lebioda89@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning reported by checkpatch.pl:

WARNING: else is not generally useful after a break or return
235: FILE: drivers/staging/nvec/nvec.c:235

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/nvec/nvec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 90f1c4d..8a3dd47 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -232,8 +232,7 @@ static size_t nvec_msg_size(struct nvec_msg *msg)
 		return 2;
 	else if (event_length == NVEC_3BYTES)
 		return 3;
-	else
-		return 0;
+	return 0;
 }
 
 /**
-- 
1.8.3.2

