Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaL2ObN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:31:13 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14761 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbaL2ObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:31:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QAHdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQmjxMBAQEHIoYDiRBkBxaEEwWMPopKkVAig289MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 08/11 linux-next] [media] vivid: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:42 +0100
Message-Id: <1419863387-24233-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/platform/vivid/vivid-tpg.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 9dc463a4..bd8b1c7 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -20,7 +20,6 @@
 #ifndef _VIVID_TPG_H_
 #define _VIVID_TPG_H_
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/random.h>
-- 
2.1.0

