Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaGGWcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:32:04 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35299 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGGWcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:32:01 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 1/5] staging:nvec: Fix "unnecessary else" coding style warning.
Date: Tue,  8 Jul 2014 00:31:33 +0200
Message-Id: <1404772297-6549-2-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1404772297-6549-1-git-send-email-gclement@baobob.org>
References: <1404772297-6549-1-git-send-email-gclement@baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last else is unnessary as all the if statements end with a return.

Signed-off-by: Guillaume Clément <gclement@baobob.org>
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
1.8.5.5

