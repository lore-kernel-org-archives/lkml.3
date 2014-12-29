Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaL2Oad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:30:33 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:1421 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbaL2OaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:30:14 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QAEhkoVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQojxMBAQEHIoYDiRBkBxaEEwWMPopKkVAig289MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 02/11 linux-next] skd: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:36 +0100
Message-Id: <1419863387-24233-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/skd_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1e46eb2..542353a 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -34,7 +34,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
-#include <linux/version.h>
 #include <linux/err.h>
 #include <linux/scatterlist.h>
 #include <linux/aer.h>
-- 
2.1.0

