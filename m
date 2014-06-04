Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaFDN6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:58:30 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:59481 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaFDN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:58:28 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH 4/4] GenWQE: Increase driver version number
Date: Wed,  4 Jun 2014 10:57:53 -0300
Message-Id: <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
References: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060413-9564-0000-0000-000000FD1C68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase genwqe driver version number.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/genwqe_driver.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
index cd52631..a506e9a 100644
--- a/drivers/misc/genwqe/genwqe_driver.h
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -36,7 +36,7 @@
 #include <asm/byteorder.h>
 #include <linux/genwqe/genwqe_card.h>
 
-#define DRV_VERS_STRING		"2.0.15"
+#define DRV_VERS_STRING		"2.0.21"
 
 /*
  * Static minor number assignement, until we decide/implement
-- 
1.7.1

