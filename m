Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaL2Oab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:30:31 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:1421 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbaL2OaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:30:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QAEhkoVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQojxMBAQEHIoYDiRBkBxaEEwWMPopKkVAig289MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>
Subject: [PATCH 01/11 linux-next] rsxx: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:35 +0100
Message-Id: <1419863387-24233-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/rsxx/rsxx_priv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rsxx/rsxx_priv.h b/drivers/block/rsxx/rsxx_priv.h
index 6bbc64d..21adc25 100644
--- a/drivers/block/rsxx/rsxx_priv.h
+++ b/drivers/block/rsxx/rsxx_priv.h
@@ -25,7 +25,6 @@
 #ifndef __RSXX_PRIV_H__
 #define __RSXX_PRIV_H__
 
-#include <linux/version.h>
 #include <linux/semaphore.h>
 
 #include <linux/fs.h>
-- 
2.1.0

