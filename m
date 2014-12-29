Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaL2Oeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:34:50 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:8521 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaL2Oer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:34:47 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QALdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQmjxMBAQEBBgIghgOJEGQHFoQTBYw+ikqRUCKDbz0xgQOBQAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 11/11 linux-next] s390/hmcdrv: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:34:39 +0100
Message-Id: <1419863679-24430-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/char/hmcdrv_mod.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/char/hmcdrv_mod.c b/drivers/s390/char/hmcdrv_mod.c
index 505c6a7..251a318 100644
--- a/drivers/s390/char/hmcdrv_mod.c
+++ b/drivers/s390/char/hmcdrv_mod.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/stat.h>
 
 #include "hmcdrv_ftp.h"
-- 
2.1.0

