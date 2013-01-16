Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3APOux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:50:53 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33925 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab3APOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:33 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 07/11] remoteproc: Add state RPROC_LOADED
Date: Wed, 16 Jan 2013 15:43:46 +0100
Message-Id: <1358347430-9243-8-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add state RPROC_LOADED as firmware loading and startup will be
different states.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_debugfs.c |    1 +
 include/linux/remoteproc.h              |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 157a573..a026359 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -68,6 +68,7 @@ static const char * const rproc_state_string[] = {
 	"suspended",
 	"running",
 	"crashed",
+	"loaded",
 	"invalid",
 };
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index faf3332..17b8120 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -357,7 +357,8 @@ enum rproc_state {
 	RPROC_SUSPENDED	= 1,
 	RPROC_RUNNING	= 2,
 	RPROC_CRASHED	= 3,
-	RPROC_LAST	= 4,
+	RPROC_LOADED    = 4,
+	RPROC_LAST	= 5,
 };
 
 /**
-- 
1.7.5.4

